FROM rocker/r-ubuntu

RUN apt-get update && apt-get install -y pandoc

RUN mkdir /project
WORKDIR /project

RUN mkdir code
RUN mkdir output
COPY code code
COPY Makefile .
COPY report.Rmd .

COPY .Rprofile .
COPY renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.dcf renv

RUN Rscript -e "renv::restore(prompt = FALSE)"

RUN mkdir final_report
