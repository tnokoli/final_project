pacman::p_load(
  rio,          # File import
  here,         # File locator
  tidyverse,    # data management + ggplot2 graphics, 
  stringr,      # manipulate text strings 
  purrr,        # loop over objects in a tidy way
  gtsummary,    # summary statistics and tests 
  broom,        # tidy up results from regressions
  lmtest,       # likelihood-ratio tests
  parameters,   # alternative to tidy up results from regressions
  see,          # alternative to visualize forest plots
  ggplot2,
  tidyquant,
  lubridate,
  slider,
  RColorBrewer
  )

#load packages
library(tidyverse)
library(slider)
library(tidyquant)
library(lubridate)

pacman::p_load(
  rio,           # import/export
  here,          # filepaths
  lubridate,     # working with dates
  forcats,       # factors
  aweek,         # create epiweeks with automatic factor levels
  janitor,       # tables
  tidyverse      # data mgmt and viz
)

#Import dataset (you'll have to upload), clean names
  library(readr)
diabetes <- read_csv("~/Downloads/diabetes_012.csv")
View(diabetes)
  janitor::clean_names()


diabetes <- diabetes %>% 
  mutate(Phys_Cat = case_when(
    # criteria                                   # new value if TRUE
    PhysHlth < 5                        ~ "bad",
    PhysHlth >= 5 & PhysHlth < 15 ~ "good",
    PhysHlth >= 15                       ~ "very good",
    is.na(PhysHlth)                     ~ NA_character_,
    TRUE                                       ~ "Check me"))  


###rename

diabetes <- diabetes %>% 
  mutate(Diabetes_012 = recode(Diabetes_012,
                           # for reference: OLD = NEW
                           "0"  = "Not Diabetic",
                           "2"  = "Diabetic",
                      ))

diabetes <- diabetes %>% 
  mutate(bmi_cat = case_when(
    # criteria                                   # new value if TRUE
    BMI < 20                        ~ "low",
    BMI >= 20 & BMI < 30 ~ "medium",
    BMI >= 30                       ~ "high",
    is.na(BMI)                     ~ NA_character_,
    TRUE                                       ~ "Check me"))  


###
RUN ONE CODE CHUNK AT A TIME
############


# Diabetic status wrt bmi
ggplot(diabetes %>% drop_na(Diabetes_012)) + 
  geom_bar(aes(y = BMI, fill = Diabetes_012), width = 0.7) +
  theme_minimal()+
  theme(legend.position = "bottom") +
  labs(title = "Diabetic status in relation to bmi",
       y = "BMI")
