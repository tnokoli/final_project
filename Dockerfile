FROM rocker/r-ubuntu

RUN apt-get update && apt-get install -y pandoc

RUN Rscript -e "install.packages('here')"
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('ggplpot2')"
RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('tidyverse')"


RUN mkdir /Final_Project
WORKDIR /Final_Project

RUN mkdir code
RUN mkdir output
COPY code code
COPY Makefile .
COPY report.Rmd .
COPY diabetes_012_health_indicators_BRFSS2015.csv .

RUN mkdir final_report




