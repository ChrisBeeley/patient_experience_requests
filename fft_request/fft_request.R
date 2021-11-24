
library(tidyverse)

board <- pins::board_rsconnect()

trust_data <- pins::pin_read(board, "chrisbeeley/trustData") %>% 
  dplyr::filter(Date >= "2017-01-01")