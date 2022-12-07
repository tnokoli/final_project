FROM rocker/r-ubuntu

RUN apt-get update && apt-get install -y pandoc

RUN Rscript -e "install.packages('here')"
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('ggplpot2')"
RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('tidyverse')"


RUN mkdir /Final_Project
WORKDIR /Final_Project/Final_Project1

RUN mkdir code
RUN mkdir output
COPY code code
COPY Makefile .
COPY report.Rmd .

COPY .Rprofile .
COPY renv/renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.dcf renv
RUN mkdir -p renv

RUN mkdir final_report
COPY Data Data
CMD make && mv report.html final_report





