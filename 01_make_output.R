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