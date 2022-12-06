pacman::p_load(
  rio,            # import/export
  here,           # file pathways
  flextable,      # make HTML tables 
  officer,        # helper functions for tables
  tidyverse)      # data management, summary, and visualization

# import the linelist
diabetes_ <- import("diabetes.csv")

diabetes_ <- diabetes_ %>% 
  mutate(Outcome = recode(Outcome,
                           # for reference: OLD = NEW
                           "1"  = "Diabetic",
                           "0"  = "Not_Diabetic"))


table <- diabetes_ %>% 
  
  # Get summary values per hospital-outcome group
  ###############################################
group_by(Age, Outcome) %>%                      # Group data
  summarise(                                           # Create new summary columns of indicators of interest
    N = n(),                                            # Number of rows per hospital-outcome group     
    sugar_level = median(Glucose, na.rm=T)) %>%           # median CT value per group
  
  # add totals
  ############
bind_rows(                                           # Bind the previous table with this mini-table of totals
  diabetes_ %>% 
    filter(!is.na(Insulin) & Outcome != "Missing") %>%
    group_by(Outcome) %>%                            # Grouped only by outcome, not by hospital    
    summarise(
      N = n(),                                       # Number of rows for whole dataset     
      sugar_level = median(Glucose, na.rm=T))) %>%     # Median CT for whole dataset
  
  # Pivot wider and format
  ########################
  pivot_wider(                                         # Pivot from long to wide
    values_from = c(sugar_level, N),                       # new values are from ct and count columns
    names_from = Outcome) %>%                           # new column names are from outcomes
  mutate(                                              # Add new columns
    N_Known = N_Diabetic + N_Not_Diabetic,                               # number with known outcome
    Pct_Diabetic = scales::percent(N_Diabetic / N_Known, 0.1),         # percent cases who died (to 1 decimal)
    Pct_Not_Diabetic = scales::percent(N_Not_Diabetic / N_Known, 0.1)) %>% # percent who recovered (to 1 decimal)
  select(                                              # Re-order columns
    Outcome, N_Known,                                   # Intro columns
    N_Not_Diabetic, Pct_Not_Diabetic, sugar_level_Not_Diabtetic,            # Recovered columns
    N_Diabetic, Pct_Diabetic, sugar_level_Diabetic)  %>%             # Death columns
  arrange(N_Known)                                    # Arrange rows from lowest to highest (Total row at bottom)

table  # print
(
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


###RUN ONE CODE CHUNK AT A TIME############


# Diabetic status wrt bmi
ggplot(diabetes %>% drop_na(Diabetes_012)) + 
  geom_bar(aes(y = BMI, fill = Diabetes_012), width = 0.7) +
  theme_minimal()+
  theme(legend.position = "bottom") +
  labs(title = "Diabetic status in relation to bmi",
       y = "BMI")

