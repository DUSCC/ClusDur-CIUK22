# ClusDur Alces Flight 22
Hello! We are team ClusDur and this is our lengthy report on the AlcesFlight challenge. Well, this bit isn't, this is a general overview of the entire challenge. We have a lengthy 11 pages (have fun marking) in the pdf in this repository for you to delve deeper. To make things slightly easier, we'll give you an overview of each part of the marking scheme that we did for you to review and check in our pdf. 

The pdf is slightly chucked together, and rather than editing all of that to sound perfect and cover every point concisely, it's easier to pretty much start afresh and use that as a "technical report" to scoop up all the extra marks and prove/explain everything.


## Challenge 1 - Virtual or Bare Metal?
For the majoirty of tests, we used the Dell R6525 1U enterprise servers (the AMD EPYC 7763 128 cores), both virtual and bare metal. For some tests (and we shall specify), we used Dell R650 1U (Intel Xeon Silver 4314 16 cores) due to other nodes being unavailable at the times of testing.

```markdown
| Characteristic                         	| Metric  	| Theoretical Peak   	| Virtual  	| Bare-metal 	|
|----------------------------------------	|---------	|--------------------	|----------	|------------	|
| Single core integer performance        	| Kpos/s  	| 13755              	| 10319.2  	| 14551.0    	|
| Single core floating point performance 	| GFLOP/s 	| 56                 	| N/A :(   	| 47.04      	|
| Multi-core floating point performance  	| GFLOP/s 	| 5017.6             	| 1824     	| 2913.1     	|
| Memory Bandwidth                       	| MB/s    	| 25600              	| 92329.4  	| 933796     	|
| Interconnect Latency                   	| ms      	| 0.044336             	| 0.247251 	| N/A :)     	|
| Interconnect Bandwidth                 	| MB/s    	| 3125               	| 560.37   	| N/A :)     	|
| I/O Write - 1 Core                     	| MB/s    	| N/A :)             	| 371.33   	| 376.42     	|
| I/O Read - 1 Core                      	| MB/s    	| N/A :)             	| 14449.73 	| 15156.86   	|
| I/O Write - 64 Core                    	| MB/s    	| N/A :)             	| 394.92   	| 399.84     	|
| I/O Read - 64 Core                     	| MB/s    	| Yet another N/A :D 	| 46897.26 	| 108879.39  	|
```
![image](Alces%20Graphs.png)

You can clearly see we benchmarked quite a few things (definitely didn't take us 3 hours). The main takeaway is that Bare Metal typically performed noticably better than Virtual instances. We weren't too surprised at many of our results, but sadly missed some of them (namely bare metal interconnect) because we struggled to get two of the same instance types up simultaneously by the time we got around to testing those things. We tried!

In our report, we detail how we got these results and try and make sense of them so you should go and read that.

Lastly, we hope you appreciated our SSH keypair name - AlSSH-Flight. We had a lot of trouble saying this for the first couple of days, and we hope you do too!

We've just taken to saying it as  "Alces - es - h" and it worked (somewhat)
## Challenge 2 - Application Benchmark
For this we can really show our results compactly! You should definitely go and check our report for plenty more detail however.
```markdown
| Run           	| Instance              	| Processor 	| Performance (ns/day) 	| Execution Time (s) 	| Run Cost (£) 	| Energy (KJ) 	|
|---------------	|-----------------------	|-----------	|----------------------	|--------------------	|--------------	|-------------	|
| Fastest       	| baremetal.nvidia.a100 	| GPU       	| 8.478                	| 10.212             	| £0.013       	| 28.59       	|
| Lowest Cost   	| baremetal.intel.25gb  	| CPU       	| 3.873                	| 44.634             	| £0.0057      	| 16.96       	|
| Lowest Carbon 	| baremetal.intel.25gb  	| CPU       	| 3.873                	| 44.634             	| £0.0057      	| 16.96       	|
```
As you can see, while we still got a reasonably impressive run on the Nvidia a100s, we managed to get our runs so fast (while providing alright performance) that they use pretty much no running cost (less than a single pence of energy) and minimal carbon emissions through energy usage (10x less energy than boiling your kettle (165 KJ) on the intel nodes). If running some chunky 4 GPU monster on some impressive benchmark is cheaper and better for the environment than the coffee you're drinking right now!
## Challenge 3 - Automated cloud workflow
Now this really was our magnum opus. We are incredibly proud of our workflow performance. Our amazing Sys-admin teammate Darius put this all together (thank you Darius!) so be prepared:
* We use Python, Ansible AND Bash to provision our software stack
* We have one BEAUTIFUL python script that can both launch, shutdown AND delete our nodes with minimal input
* A further script to install all dependencies and run most of our tests (with a smidge more time this could execute all of them we promise)
* Finally, retrieve all our results onto the login node and shut down + delete the instance. From there we can easily upload to this github
* Our workflow includes: 
	* Launch the instance
	* Delete the instance if it fails
	* Provision the instance
	* Run all benchmarks
	* Return all the results to the login node
	* Shut down and delete the instance automatically
	* Push all results to github for safety (manually sadly)
	
![image](Alces%20Workflow.png)

This workflow only takes 7.5 minutes to run entirely on a virtual instance and 15 minutes on a bare-metal instance! That's crazy fast but the gap between the two would narrow the more work they have (as the overhead of spinning up a bare metal instance would reduce). This means that the entire work flow stays incredibly economical yet provides good results.

We'd therefore like to say that we'd personally choose the AMD 128 core nodes for a perfect mix of economical, green and still very very fast. We'd also pick bare metal over virtual, as while these cost you a little more, the absolute cost barely rises yet we see a moderate gain in performance.

We think that although our results arent reported in the flashiest way (sorry, no skywriting above your offices), the complexity of our automated workflow allows for an impressive reporting method which stem from a SINGLE command to launch the instances, run all benchmarks and return the results. Don't look at this as a flashy sports car, but rather a swiss army knife that can do literally everything you want. That goes for our trigger action too - no need for anything too flashy when all you need is a single command to do all your work for you. To us, THAT is more impressive than some big red button with lights that you need to press several times to execute the next stage of your workflow.

Now... you thought you were done. We just wanted to leave you with this abomination to really send the message home:
https://www.youtube.com/shorts/unm8PH25gGE

---------------------
We hope you have fun marking this, and please check our PDF for more details!
Thank you,
Team ClusDur
