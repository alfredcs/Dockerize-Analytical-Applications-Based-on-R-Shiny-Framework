FROM r-base:latest

MAINTAINER Alfred Shen "alfred.shen1@ge.com"

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev\
    libssl-dev

# Download and install shiny server
RUN wget --no-verbose "https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.4.6.809-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'curl', 'leaflet', 'RColorBrewer', 'scales', 'lattice', 'dplyr', 'DT', 'plotrix'), repos='https://cran.rstudio.com/', dependencies=TRUE)" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

EXPOSE 3838 5930

COPY shiny-server.sh /usr/bin/shiny-server.sh
VOLUME /opt/apps
CMD ["bin/shiny-server.sh"]
