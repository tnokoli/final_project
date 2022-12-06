
# Contents
## Code
The code folder contains: 
  1. 01_make_output.Rmd - this file creates the table featured in the final document
  2. 02_render_report.Rmd - this file create the figure featured in the final document
  

## report.rmd
Final R-markdown, it uses the code from the two R-markdowns in the code folder to build the figure and the table.

## render_report.R
This is an R-script to render the Project.Rmd file.

## Makefile 
Sets the rules for making the final report.


# BUILD REPORT 
In order to generate the report, you must first build the docker image associated with the project.To do so, you may enter "docker build -t project_image ." in the terminal or "make pull" 

After you have built the image, you can produce the report. This is done by running the container you have just built. In the terminal, run the command "make project" respectively. You will find the final report in the "report" folder. 

