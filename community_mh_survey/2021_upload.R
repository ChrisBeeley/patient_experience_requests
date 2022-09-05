
library(dplyr)

db_conn <- odbc::dbConnect(drv = odbc::odbc(),
                           driver = "Maria DB",
                           server = Sys.getenv("HOST_NAME"),
                           UID = Sys.getenv("DB_USER"),
                           PWD = Sys.getenv("MYSQL_PASSWORD"),
                           database = "SUCE",
                           Port = 3306)


dfFinal = readxl::read_excel("CMHS_Dec21.xlsx")

### CHANGE DATE AND TIME CODE FOR BOTH


dfFinal <- dfFinal %>% 
  purrr::set_names(c("Unit", "Best", "Improve", "BestComment2"))

dfFinal$Date = as.Date("2021-02-01")

dfFinal$Best <- paste(
  ifelse(is.na(dfFinal$Best), "", paste0(dfFinal$Best, "####")), 
  ifelse(is.na(dfFinal$BestComment2), "", paste0("????", dfFinal$BestComment2))
)

dfFinal$Time = 48

dfFinal$addedby = "NMHS"

dfFinal$Optout = "No"

dfFinal <- dfFinal %>% 
  mutate(TeamC = case_when(
    Unit == "AMH" ~ 2020,
    Unit == "MHSOP" ~ 2070,
    TRUE ~ NA_real_
  )) %>% 
  select(-Unit, -BestComment2)

DBI::dbWriteTable(db_conn, "Local", dfFinal, append = TRUE, row.names = FALSE)

DBI::dbDisconnect(db_conn)