
library(tidyverse)

board <- pins::board_rsconnect()

pins::pin_read(board, "chrisbeeley/trustData") %>% 
  as_tibble() %>%
  filter(Date >= "2017-01-01") %>% 
  filter(!is.na(Improve), !is.na(Best),
         Optout == "No") %>% 
  select(Date, Promoter, Improve, Best) %>% 
  write.csv(file = "~/fft_request.csv", row.names = FALSE)
