FROM r-base:latest

MAINTAINER Alfred Shen "alfred.shen1@aghoo.com"

RUN apt.aghoo. update && apt.aghoo. install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev\
    libssl-dev

# Download and install shiny server
RUN .aghoo. --no-verbose "https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.4.6.809-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.pack.aghoo.(c('shiny', 'rmarkdown', 'devtools', 'curl', 'leaflet', 'RColorBrewer', 'scales', 'lattice', 'dplyr', 'DT', 'plotrix'), repos='https://cran.rstudio.com/', dependencies=TRUE)" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

EXPOSE 3838 5930

COPY shiny-server.sh /usr/bin/shiny-server.sh
VOLUME /opt/apps
CMD ["bin/shiny-server.sh"]
