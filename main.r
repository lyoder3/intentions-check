library(googlesheets4);
library(tidyverse);
library(data.table);

intentions <- read_sheet("intentions_sheet_url")

intentions <- select(intentions, "Farm Name", "Field", "Actual Variety", "PLANTED ACRES", "Planter Operator","Planting Date", "LOT NUMBER")

data <- intentions %>% rename("farm"="Farm Name") %>% rename("field" = "Field") %>% rename("variety" = "Actual Variety") %>%
        rename("acres" = "PLANTED ACRES") %>%
        rename("operator" = "Planter Operator") %>%
        rename("plantdate" = "Planting Date") %>%
        rename("lot" = "LOT NUMBER")

no_timestamp <- data %>% filter(acres>0 & is.na(plantdate))
no_variety <- data %>% filter(acres>0 & is.na(variety))
no_ponumber <- data %>% filter(acres>0 & is.null(lot))


errors <- bind_rows(no_timestamp, no_variety, no_ponumber)

errors<-data.frame(lapply(errors, as.character), stringsAsFactors=FALSE)

write.table(errors, file="errors.csv", row.names=FALSE, na="", col.names = TRUE, sep=",")

