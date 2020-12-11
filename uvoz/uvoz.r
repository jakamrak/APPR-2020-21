## 2. faza: Uvoz podatkov
#
#sl <- locale("sl", decimal_mark=",", grouping_mark=".")
#
## Funkcija, ki uvozi občine iz Wikipedije
#uvozi.obcine <- function() {
#  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
#  stran <- html_session(link) %>% read_html()
#  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
#    .[[1]] %>% html_table(dec=",")
#  for (i in 1:ncol(tabela)) {
#    if (is.character(tabela[[i]])) {
#      Encoding(tabela[[i]]) <- "UTF-8"
#    }
#  }
#  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
#                        "ustanovitev", "pokrajina", "regija", "odcepitev")
#  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
#  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
#  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
#  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
#    if (is.character(tabela[[col]])) {
#      tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
#    }
#  }
#  for (col in c("obcina", "pokrajina", "regija")) {
#    tabela[[col]] <- factor(tabela[[col]])
#  }
#  return(tabela)
#}
#
## Funkcija, ki uvozi podatke iz datoteke druzine.csv
#uvozi.druzine <- function(obcine) {
#  data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
#                    locale=locale(encoding="Windows-1250"))
#  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
#    strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
#  data$obcina[data$obcina == "Sveti Jurij"] <- iconv("Sveti Jurij ob Ščavnici", to="UTF-8")
#  data <- data %>% pivot_longer(`1`:`4`, names_to="velikost.druzine", values_to="stevilo.druzin")
#  data$velikost.druzine <- parse_number(data$velikost.druzine)
#  data$obcina <- parse_factor(data$obcina, levels=obcine)
#  return(data)
#}

# Zapišimo podatke v razpredelnico obcine
#obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
#druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.


library(rjson)
library(readxl)
library(tidyr)
library(dplyr)
library(readr)
library(rvest)

#GRADBENA DOVOLJENJA LETNO

#definiramo nova imena stolpcev
stolpci.dovoljenja <- c("StatisticnaRegija", "Investitor", "TipStavbe", "Leto", "SteviloStavb", "PovrsinaStavb")

#preberemo datoteko
gradbena.dovoljenja.letno.zacetna <- read_csv("podatki/gradbena-dovoljenja-po-regijah-letno.csv",
                                              locale = locale(encoding = "windows-1250")) %>% as.data.frame()
  
#preimenujemo stolpce
colnames(gradbena.dovoljenja.letno.zacetna) <- stolpci.dovoljenja 

#zdruzimo po regijah in letih
gradbena.dovoljenja.letno <- gradbena.dovoljenja.letno.zacetna %>% 
  group_by(StatisticnaRegija, Leto) %>% 
  summarise(SteviloStavb=sum(SteviloStavb), Povrsina_m2=sum(PovrsinaStavb))


#INDEKS CEN GRADBENIH STROŠKOV

#definirao nova imena stolpcev
stolpci.gradb.stroski <- c("Cetrtletje", "SkupajStroski", "StroskiMateriala", "StroskiDela")

#preberemo datoteko

gradbeni.stroski <- read_delim("podatki/gradb-stroski-cetrtletno.csv",";",locale =
locale(encoding = "windows-1250", decimal_mark = "."),skip = 2) %>% 
  as.data.frame()

#preimenujemo stolpce
colnames(gradbeni.stroski) <- stolpci.gradb.stroski



#GRADBENA DOVOLJENJA MESEC SEPT

gradb.dovoljenja.sept.uvoz <- read_csv2("podatki/gradb-dovoljenja-sept.csv", 
                                        skip=2, locale=locale(encoding = "windows-1250"))

gradb.dovoljenja.sept <- gradb.dovoljenja.sept.uvoz %>%
  select(-3, -5) %>%
  rename(StatisticnaRegija=1, VrstaObjekta=2, SteviloStavb=3, )


#INDEKS CEN ARHITEKTURNEGA PROJEKTIRANJA

#uvozimo pdatke
indeks.cen.arh.proj.uvoz <- read_delim("podatki/arh-proj.csv", ";",
                                  locale = locale(encoding = "windows-1250",
                                                  decimal_mark = "."), skip = 2) %>% as.data.frame()


indeks.cen.arh.proj <- indeks.cen.arh.proj.uvoz %>% 
  rename(INDEKS=3, SKD=`SKD DEJAVNOST`) %>%   # poenostavitev imen
  separate(ČETRTLETJE, c("LETO", "CETR"), "Q") %>% # razbitje na dva stolpca
  group_by(LETO, SKD) %>% # grupiranje po letih, SKD damo samo še zraven, ker je itak isti
  summarise(POV_INDEKS=mean(INDEKS)) %>%
  select(-2) #odstranimo stolpec skd saj nam ne rabi


#INDEKS POVPREČNE MESEČNE NETO PLAČE PO REGIJAH

#uvozimo podatke
indeks.neto.plac <-  read_csv("podatki/indeks-povp-mes-neto-place-regije.csv", 
                         locale = locale(encoding = "windows-1250", 
                                         decimal_mark = ".")) %>% as.data.frame() 

#definiramo nova imena stolpcev
stolpci.place <- c("StatisticnaRegija", "Leto", "Indeks")

#preimenujemo stolpce
colnames(indeks.neto.plac) <- stolpci.place


#DELEŽ NASELJENIH STANOVANJ BREZ OSNOVNE INFRASTRUKTURE

#uvozimo podatke
stanovanja.brez.os.infra.uvoz <- read_xlsx("podatki/stanovanja-brez-os-infrastrukture.xlsx", 
                                           skip = 2, n_max = 36)


stanovanja.brez.os.infra <- stanovanja.brez.os.infra.uvoz %>% 
  fill(1:3) %>% #dodamo manjkajoče podatke imen regij
  rename(StatisticnaRegija=1, Leto=2, 'Delez_%'=3) %>% #preimenujemo stolpce
  mutate(Leto=as.integer(Leto))  #spremenimo class za stolpec leto v numeric



#VREDNOST OPRAVLJENIH GRADBENIH DEL

json.file <- "podatki/vrednost-opravljenih-gradb-del-v-1000-eur.json"
#json.podatki <- fromJSON(readLines(json.file)) %>% as.data.frame()

