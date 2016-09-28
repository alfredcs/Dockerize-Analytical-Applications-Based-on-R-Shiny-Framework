Using R/Shine to deploy a web based analytical application then Dcokerized it for heterogeneous environment deployments. 

Examples: 

1. Build da docker image 
   %docker build --rm -t rshiny:1.4.6 .

2. Run containerized service
   %docker run -d -v /opt/apps:/opt/apps -P 5930:5930 rshiny:1.4.6 Rscript runEngines.R
