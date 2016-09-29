This demo includes methods along with codes to analyze big data with R and to develop an interactive Web application based on Shiny. It also has examples on how to pack runtime libraries and build an agile container image. The container has been deployed to heterogeneous environments including edge device, private and public cloud by using simple Docker CLI, Swarm or Mesos orchastration framework. This is an end-to-end solution covering wide spectrum from data injection, data analysis with ML franework to service deployment.  

##### Data Injection and Analysis
Inject data from multiple source and analyze data using R. Use Kafka, Spark and Cassnadra for large data volume. 

##### Interactive Web Presentation Development
Develope Web applications on R nad Shiny. Machine learning will be added.
 
##### Containerize Service and Data 
Pack applications and runtime libraries into a Docker image.   

##### Service Deployment Orachastration  
Dockerized service can be seemlessly deployed to edge device, public or private cloud. The data driven service can be deployed to multiple availability zones with dynamic scalability.

####Examples:

    1. Build da docker image:  %docker build --rm -t rshiny:1.4.6 .

    2. Deploy a containerized servicei on an appliance:  %docker run -d -v /opt/apps:/opt/apps -P 5930:5930 rshiny:1.4.6 Rscript runEngines.R

    3. Use Marathon to deploy service to a Mesos farm on a public or private cloud.

The dockerized applpication has been deployed on an [edge server](http://3.39.90.51:8080/) as well as on [AWS](http://10.202.89.121).
