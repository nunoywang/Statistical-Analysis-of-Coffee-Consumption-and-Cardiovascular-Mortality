library(readr)
library(dplyr)

ecg <- read.csv("ecg.csv")
coffee <- read.csv("coffee.csv")
coffeetypes <- read.csv("coffee_types.csv")
iff <- read.csv("iff.csv")
mort <- read.csv("mort.csv")
info <- read.csv("info.csv")

##Filtering values (e.g. 8888 error value)
ecg_filtered <- ecg %>% filter(PAXIS != 8888, PAMP1 != 8888)

coffee_filtered <- coffee %>% filter(COFFEE != 8888)

info <- info %>% mutate(CIGARETTES = ifelse(is.na(CIGARETTES), 0, CIGARETTES),
                        HYPERTENSION = ifelse(is.na(HYPERTENSION), 0, HYPERTENSION),
                        TIME_SMOKING = ifelse(TIME_SMOKING == 777, 0, TIME_SMOKING))

info <- info %>% filter(CIGARETTES != 666, CIGARETTES != 777, 
                        CIGARETTES != 888, CIGARETTES != 999,
                        (TIME_SMOKING != 888 & TIME_SMOKING != 999) | is.na(TIME_SMOKING),
                        ACTIVE != 8, ACTIVE != 9, HYPERTENSION != 8, HYPERTENSION != 9, 
                        DIABETES != 8, DIABETES != 9)

mort <- mort %>% filter(TIME != ".")

##Summing all caffeine per participant
iff_total <- iff %>%
  group_by(SEQN) %>%
  summarise(CAFFEINE = sum(CAFFEINE, na.rm = TRUE))

##Calculating age at death
mortage <- inner_join(info %>% select(SEQN, AGE), mort %>% select(SEQN, TIME), by = "SEQN")
age_death <- data.frame(mortage$SEQN, mortage$AGE + is.numeric(mortage$TIME) / 12)
names(age_death)[1] <- "SEQN"
names(age_death)[2] <- "AGE.DEATH"


# ======= Datasets with all covariables FOR COFFEE INTAKE ======= #

###Datasets for abnormal P wave axis
##Dataset with only the participants with all the data
data_paxis <- info %>%
  inner_join(ecg_filtered %>% filter(PAXIS < 0 | PAXIS > 75), by = "SEQN") %>%
  inner_join(coffee_filtered, by = "SEQN") %>%
  inner_join(iff_total, by = "SEQN") %>%
  inner_join(mort %>% select(SEQN, MORTSTAT, CAUSE, TIME), by = "SEQN") %>%
  inner_join(age_death, by = "SEQN")

data_paxis$AGE.DEATH <- ifelse(data_paxis$MORTSTAT == 0, NA, data_paxis$AGE.DEATH)
data_paxis$TIME <- ifelse(data_paxis$MORTSTAT == 0, NA, data_paxis$TIME)

##Frequency of causes of death
paxis_cause <- data_paxis %>% count(CAUSE)


###Datasets for abnormal negative P wave amplitude in lead V1
##Dataset with only the participants with all the data
data_pamp <- info %>%
  inner_join(ecg_filtered %>% filter(PAMP1 < -100), by = "SEQN") %>%
  inner_join(coffee_filtered, by = "SEQN") %>%
  inner_join(iff_total, by = "SEQN") %>%
  inner_join(mort %>% select(SEQN, MORTSTAT, CAUSE, TIME), by = "SEQN") %>%
  inner_join(age_death, by = "SEQN")

data_pamp$AGE.DEATH <- ifelse(data_pamp$MORTSTAT == 0, NA, data_pamp$AGE.DEATH)
data_pamp$TIME <- ifelse(data_pamp$MORTSTAT == 0, NA, data_pamp$TIME)

##Frequency of causes of death
pamp_cause <- data_pamp %>% count(CAUSE)

# ======= Datasets with all covariables FOR COFFEE TYPE ======= #

###Datasets for abnormal P wave axis
##Dataset with only the participants with all the data
data_type_paxis <- info %>%
  inner_join(ecg_filtered %>% filter(PAXIS < 0 | PAXIS > 75), by = "SEQN") %>%
  inner_join(coffeetypes, by = "SEQN") %>%
  inner_join(mort %>% select(SEQN, MORTSTAT, CAUSE, TIME), by = "SEQN") %>%
  inner_join(age_death, by = "SEQN")

data_type_paxis$AGE.DEATH <- ifelse(data_type_paxis$MORTSTAT == 0, NA, data_type_paxis$AGE.DEATH)
data_type_paxis$TIME <- ifelse(data_type_paxis$MORTSTAT == 0, NA, data_type_paxis$TIME)

##Frequency of causes of death
paxis_type_cause <- data_type_paxis %>% count(CAUSE)


###Datasets for abnormal negative P wave amplitude in lead V1
##Dataset with only the participants with all the data
data_type_pamp <- info %>%
  inner_join(ecg_filtered %>% filter(PAMP1 < -100), by = "SEQN") %>%
  inner_join(coffeetypes, by = "SEQN") %>%
  inner_join(mort %>% select(SEQN, MORTSTAT, CAUSE, TIME), by = "SEQN") %>%
  inner_join(age_death, by = "SEQN")

data_type_pamp$AGE.DEATH <- ifelse(data_type_pamp$MORTSTAT == 0, NA, data_type_pamp$AGE.DEATH)
data_type_pamp$TIME <- ifelse(data_type_pamp$MORTSTAT == 0, NA, data_type_pamp$TIME)

##Frequency of causes of death
pamp_type_cause <- data_type_pamp %>% count(CAUSE)


# ========= Legend ========= #

#SEQN: ID of each participant

#RACE:
# 1 = White
# 2 = Black
# 3 = Other
# 8 = Mexican-American of unknown race

#SEX:
# 1 = Male
# 2 = Female

#AGE: Age in years of the participant

#CIGARETTES: Number of cigarettes in a day

#TIME_SMOKING: Time in years of smoking this amount

#ACTIVE: Active compared to men/women your age
# 1 = More active
# 2 = Less active
# 3 = About the same

#HYPERTENSION:
# 1 = Yes
# 2 = No

#DIABETES:
# 1 = Yes
# 2 = No

#PAXIS: P axis value, frontal plane (degrees)

#PAMP1: P amplitude, negative phase, lead V1 (uV - microvolts)

#COFFEE: Number of times coffee was consumed in the past month

#CAFFEINE: Average daily caffeine consumption in the past month (mg - milligrams)

#TYPE: Type of coffee consumed
# 0 = decaffeinated
# 1 = caffeinated
# 2 = both

#MORTSTAT: Final mortality status
# 0 = Assumed alive
# 1 = Assumed deceased

#CAUSE: Underlying cause of death
# 1 = Diseases of heart
# 2 = Malignant neoplasms
# 3 = Chronic lower respiratory diseases
# 4 = Accidents (unintentional injuries)
# 5 = Cerebrovascular diseases
# 6 = Alzheimer's disease
# 7 = Diabetes mellitus
# 8 = Influenza and pneumonia
# 9 = Nephritis, nephrotic syndrome and nephrosis
# 10 = All other causes
# <NA> = Assumed alive, or no cause of death data available

#TIME: Time in months after exam until death

# ========================== #

write.csv(data_pamp, "data_pamp.csv", row.names = FALSE)
write.csv(data_paxis, "data_paxis.csv", row.names = FALSE)
write.csv(data_type_pamp, "data_type_pamp.csv", row.names = FALSE)
write.csv(data_type_paxis, "data_type_paxis.csv", row.names = FALSE)