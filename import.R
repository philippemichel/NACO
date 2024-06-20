

#  ------------------------------------------------------------------------
#
# Title : Import STOPNACO
#    By : PhM
#  Date : 2024-06-20
#
#  ------------------------------------------------------------------------


importph <- function() {
library(tidyverse)
library(readODS)
library(labelled)
library(janitor)
library(lubridate)
library(baseph)
#
nna <- c("NA",""," ","AUCUN", "Abs","na","Na")
tt <- read_ods("datas/stopnaco.ods", na = nna) |>
    clean_names() |>
    mutate_if(is.character, as.factor) |> 
mutate(type_fracture = fct_recode(type_fracture,
           "Col" = "Col 1",
           "Col" = "Col 2",
           "Col" = "Col 3",
           "Col" = "Col 4")) |> 
mutate(transfert = ifelse((transfert_beaumont == "yes") | (transfert_magny == "yes") | (transfert_autre == "yes"), "yes", "no" )) |> 
    relocate(transfert, .after = transfert_autre) |>
    dplyr::select( !(starts_with("transfert_"))) |>
    mutate(acide_tranexamique = cut(acide_tranexamique,
                                 include.lowest = TRUE,
                                 right = FALSE,
                                 dig.lab = 4,
                                 breaks = c(0, 0.1, 2), 
                                 labels = c("no", "yes"))) |> 
    mutate(score_asa = as.factor(score_asa))
  
  
  
  
  # bn <- read_ods("datas/stopnaco.ods", sheet=2)
  # var_label(tt) <- bn$nom


#
save(tt, file = "datas/stopnaco.RData")
}

importph()
load("datas/stopnaco.RData")

