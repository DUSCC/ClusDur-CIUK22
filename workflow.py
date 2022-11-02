#!/bin/python3

import os
import json
import time
import argparse
from datetime import timedelta


CONSTANTS = {'image': "\"Centos 8 Stream - Generic Cloud\"",
             'key-name': "alSSHflight"}

DEFAULTS = {'baremetal': {'network': "baremetal",
                          'config-drive': True,
                          **CONSTANTS},
            'vm': {'network': "vm-network",
                   'config-drive': False,
                   **CONSTANTS}
            }


class Server:
    def __init__(self, server_name, flavor):
        self.name = server_name
        self.flavor = flavor
        self.status = "BUILD"
        self.id = None
        self.floating_ip = None
        self.start_time = time.time()

        self.create()

    @property
    def elapsed_time(self):
        elapsed_time = time.time() - self.start_time
        return str(timedelta(seconds=elapsed_time))[:-7]  # remove microseconds

    def create(self):
        server_type = "vm" if "vm" in self.flavor else "baremetal"
        cli_args = ' '.join(f"--{key} {value}" for key, value in DEFAULTS[server_type].items())

        print(f"[{self.elapsed_time}] Creating server {self.name} with flavor {self.flavor}")
        output = os.popen(f"openstack server create {cli_args} --flavor {self.flavor} {self.name} -f json")
        self.id = json.loads(output.read()).get('id')

        self.allocate_floating_ip()
        while self.status == "BUILD":
            self.status = json.loads(os.popen(f"openstack server show {self.id} -f json").read()).get('status')
            print(f"\r[{self.elapsed_time}] Server in {self.status} status ", end='')
            time.sleep(5)

        print()
        if self.status == "ERROR":
            print("Build failed. Exiting.")
            self.delete()

    def allocate_floating_ip(self):
        self.floating_ip = get_floating_ip()
        if self.floating_ip is None:
            print("No available floating IPs could be allocated. Exiting.")
            self.delete()

        print(f"[{self.elapsed_time}] Attaching floating ip {self.floating_ip} to {self.name}")
        output = os.popen(f"openstack server add floating ip {self.id} {self.floating_ip}")
        print(output.read())

    def delete(self):
        print(f"[{self.elapsed_time}] Deleting server {self.name}")
        output = os.popen(f"openstack server delete {self.id}")
        print(output.read())
        exit(0)


def flavor_exists(flavor):
    flavors = set(flavor['Name'] for flavor in json.loads(os.popen("openstack flavor list -f json").read()))
    return flavor in flavors


def get_floating_ip():
    floating_ips = json.loads(os.popen("openstack floating ip list -f json").read())
    try:
        floating_ip = next(ip['Floating IP Address'] for ip in floating_ips if ip['Fixed IP Address'] is None)
    except StopIteration:
        return None

    return floating_ip


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("name", type=str,
                        help="The name of the server instance.")
    parser.add_argument("flavor", type=str,
                        help="The instance flavor to be used.")
    parser.add_argument("--no-provision", action="store_true",
                        help="Do not provision the instance. This will just create a server and assign an IP.")
    parser.add_argument("--no-delete", action="store_true",
                        help="Do not delete the instance after this workflow is complete.")

    args = parser.parse_args()

    if get_floating_ip() is None:
        print("No floating IPs could be found. Build exiting.")
        exit(0)

    if not flavor_exists(args.flavor):
        print("Flavor does not exist. Build Exiting.")
        exit(0)

    os.chdir("/home/team2/Documents/ClusDur-CIUK22")
    server = Server(args.name, args.flavor)
    if not args.no_provision:
        os.system(f"ansible-playbook -i {server.floating_ip}, ./benchmarking.yaml "
                  f"--private-key /home/team2/.ssh/alSSHflight.pem")
        os.system(f"scp -r centos@{server.floating_ip}:/home/centos/results/ ./test/")

    if not (args.no_delete or args.no_provision):
        server.delete()
