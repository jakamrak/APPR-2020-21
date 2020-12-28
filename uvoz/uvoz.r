## 2. faza: Uvoz podatkov


library(rjson)
library(readxl)
library(tidyr)
library(dplyr)
library(readr)
library(rvest)

#GRADBENA DOVOLJENJA LETNO

#preberemo datoteko
gradbena.dovoljenja.letno.zacetna <- read_csv("podatki/gradbena-dovoljenja-po-regijah-letno.csv",
                                              locale = locale(encoding = "windows-1250")) %>% as.data.frame()
  
#definiramo nova imena stolpcev
stolpci.dovoljenja <- c("StatisticnaRegija", "Investitor", "TipStavbe", "Leto", "SteviloStavb", "PovrsinaStavb")

#preimenujemo stolpce
colnames(gradbena.dovoljenja.letno.zacetna) <- stolpci.dovoljenja 

#zdruzimo po regijah in letih
gradbena.dovoljenja.letno <- gradbena.dovoljenja.letno.zacetna %>% 
  group_by(StatisticnaRegija, Leto) %>% 
  summarise(SteviloStavb=sum(SteviloStavb), Povrsina_m2=sum(PovrsinaStavb))


#INDEKS CEN GRADBENIH STROŠKOV

#preberemo datoteko
gradbeni.stroski.uvoz <- read_delim("podatki/gradb-stroski-cetrtletno.csv",";",locale =
locale(encoding = "windows-1250", decimal_mark = "."),skip = 2) %>% 
  as.data.frame()

#definirao nova imena stolpcev
stolpci.gradb.stroski <- c("Cetrtletje", "SkupajStroski", "StroskiMateriala", "StroskiDela")

#preimenujemo stolpce
colnames(gradbeni.stroski.uvoz) <- stolpci.gradb.stroski

gradbeni.stroski <- gradbeni.stroski.uvoz %>%
  separate(Cetrtletje, c("Leto", "Cetrtletje"), "Q") %>% 
  group_by(Leto) %>%
  summarise(SkupajStroski=mean(SkupajStroski), StroskiMateriala=mean(StroskiMateriala),
            StroskiDela=mean(StroskiDela)) %>%
  pivot_longer(2:4,names_to = "TipStroska",values_to = "Indeks")




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
  separate(ČETRTLETJE, c("Leto", "CETR"), "Q") %>% # razbitje na dva stolpca
  group_by(Leto, SKD) %>% # grupiranje po letih, SKD damo samo še zraven, ker je itak isti
  summarise(PovprecenIndeks=mean(INDEKS)) %>%
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
  rename(StatisticnaRegija=1, Leto=2, DelezVOdstotkih=3) %>% #preimenujemo stolpce
  mutate(Leto=as.integer(Leto))  #spremenimo class za stolpec leto v numeric



#VREDNOST OPRAVLJENIH GRADBENIH DEL

json.file <- "podatki/vrednost-opravljenih-gradb-del-v-1000-eur.json"
json.podatki <- fromJSON(file = json.file)

vrednost.gradb.del <- sapply(json.podatki$data, unlist) %>% #poberemo vn podatke
  t() %>% .[, c("key3", "values")] %>% #transponiramo in vzamemo stolpca z letom in vrednostjo
  data.frame(stringsAsFactors=FALSE) %>%   #spremenimo v data frame
  transmute(Leto=parse_number(key3), Vrednost_1000EUR=parse_number(values))  #preimenujemo in nastavimo tip
