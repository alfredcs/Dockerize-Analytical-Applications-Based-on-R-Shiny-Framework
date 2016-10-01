This repo offers a new reference architecture along with sample codes to analyze big data with R and to develop an interactive Web application based on Shiny. The application along  with runtime libraries are packaged into a Docker container image which can be deployed to heterogeneous environments including edge device, private or public cloud by using native Docker CLI/API, Swarm or Mesos/Marathon framework. The Containerized image can also be deployed on GPU enabled servers for performance enhancement in high volume and time sensitive use cases. This is a data and service driven platform model which is capable of receiving dynamic data injections from multiple sources and supporting agile software deployment while containers are serving customer requests. The demo offers an end-to-end solution ranging from data injection with analysis/ML processing, application development and service deployment.  

##### Data Injection and Analysis
Inject data from multiple sources and analyze data using R. To leverage Kafka, Spark and Cassandra for large data volume. 

##### Interactive Web Presentation Development
Develope interactive Web applications on Shiny and depending runtimes. Machine learning framework will be added.
 
##### Containerize Service and Data 
Pack applications and runtime libraries into a Docker image.   

##### Service Deployment Orchestration
Dockerized service can be seamlessly built, maintained and deployed with simplicity. Dependency on IaaS and PaaS will be reduced singnidicantly. The platform allows a single or massive deployment without change configuration parameters. High Scalability and redundancy are embedded in the reference architecture.

####Examples:

    1. Build a docker image:  %docker build --rm -t rshiny:1.4.6 .

    2. Deploy a containerized servicei on an appliance:  %docker run -d -v /opt/apps:/opt/apps -P 5930:5930 rshiny:1.4.6 Rscript runEngines.R

    3. Use Marathon to deploy service to a Mesos farm on a public or private cloud: %curl -X POST http://<marthon_api>:8080/v2/apps -d @eingines.json -H "content-type:application/json"

The dockerized applpication has been deployed on an [edge server with CPU](http://<vpn_ip>:<port>/) and [GPU]()  as well as on [AWS](http://<elb_ip>:<port>). 
