

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
limg <- dmy("30/09/2021")
nna <- c("NA",""," ","AUCUN", "Abs","na","Na")
tt <- read_ods("datas/stopnaco.ods", na = nna) |>
    clean_names() |>
  mutate(date_entree = mdy_hm(date_entree)) |> 
  mutate(date_incision = mdy_hm(date_incision)) |>
  mutate(delai_chirurgical = as.numeric(difftime(date_incision, date_entree, units = "hours"))) |>
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
    mutate(score_asa = as.factor(score_asa)) |> 
   mutate(charlson = cut(charlson,
                           include.lowest = TRUE,
                           right = FALSE,
                           dig.lab = 4,
                           breaks = c(-1, 4, 6, 9, 15),
                           labels = c("<4", "4-5", "6-9", "10 et +"))) |> 
  mutate(groupe = ifelse(date_entree < limg, "avant", "après")) |> 
  mutate(groupe = as.factor(groupe)) |>
  mutate(groupe =   fct_relevel(groupe,
    "avant", "après"
  )) |> 
  mutate(delai48 =as.factor(ifelse(delai_chirurgical>48,"> 48 h", "< 48 h")))

  
  
  
  
  # bn <- read_ods("datas/stopnaco.ods", sheet=2)
  # var_label(tt) <- bn$nom


#
save(tt, file = "datas/stopnaco.RData")
}

importph()
load("datas/stopnaco.RData")

