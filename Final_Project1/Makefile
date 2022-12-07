report.html: report.Rmd code/02_render_report.R diabetes_output
	Rscript code/02_render_report.R

diabetes_output:
	Rscript code/01_make_output.R 
	
.PHONY: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"
	
# DOCKERRULE
PROJECTFILES = report.Rmd code/01_make_output.R code/02_render_report.R Makefile
RENVFILES = renv.lock renv.activate.R renv/settings.dcf

#build image
tnokoli/final_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t tnokoli/project_image .
	touch $@

#run container
final_report/report.html:
	docker run -v "/$(pwd)/final_report":/Final_Project1/final_report tnokoli/project_image

