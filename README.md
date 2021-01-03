# Analiza podatkov s programom R, 2020/21

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2020/21

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jakamrak/APPR-2020-21/master?urlpath=shiny/APPR-2020-21/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jakamrak/APPR-2020-21/master?urlpath=rstudio) RStudio

## Analiza gradbeništva v Sloveniji

### Osnovna ideja
Za projektno nalogo sem si izbral tematiko gradbeništva. Osredotočil se bom na obdobje od leta 2010 do danes, saj se je v tem obdobju, po letu 2010/11, v Sloveniji začela kazati gospodarska kriza tudi v gradbenem sektorju in na nepremičninskem trgu, ki se ga v teji nalogi sicer  ne bom dotaknil. Iskal bom povezave med **skupno površino bodočih stanovanj** (na podlagi izdanih gradbenih dovoljenj) ter **številom le-teh**. Kasneje se bom dotaknil tudi kohezije med **cenami arhitekturnega projektiranja** in **vrednostjo opravljenih gradbenih del** v posameznem letu, analiziral bom **gradbene stroške** skozi leta ter za konec primerjal indeks **povprečne neto plače** z deležem naseljenih stanovanj **brez osnovne infrastrukture** po regijah. V nekaterih primerih podatki niso na voljo za vsako leto, vendar le za vsaki dve  oziroma tri, a to ne bo vplivalo na kasnejšo analizo. 

### Potek dela
* Najprej bom, na podlagi zadnjih razpoložjivih podatkov o izdanih gradbenih dovoljenjih za stanovanja po statističnih regijah Slovenije, napovedal kje se bo v prihodnosti gradilo največ oziroma najmanj stanovanjskih objektov ter podatke v deležih gradbenih dovoljenj prikazal s tortnim diagramom. 

* V nadaljevanju se bom osredotočil na gibanje gradbenih stroškov in njihovih dveh komponent (stroški dela in stroški materiala) skozi leta ter komentiral svoje ugotovitve. V kasnejši fazi bom primerjal gibanje stroškov dela z vrednostjo opravljenih gradbenih del v posameznem letu.

* Kasneje bom opazoval povezavo med indeksom cen arhitekturnega projektiranja, ki je tesno povezano z gradbeništvom, in vrednostjo opravljenih gradbenih del v posameznem letu ter to prikazal v linijskem grafikonu, kjer bo lepo viden skupen trend in korelacija med obema kazalcema.

* V tem delu bom v treh ločenih grafih, saj imam podatke za samo 3 leta (2011, 2015, 2018), s točkovinm grafom prikazal povezavo med deležem naseljenih stanovanj brez osnovne infrastrukture in indeksom povprečne mesečne neto plače. Analiziral bom vsako regijo posebej in iskal povezave med kazalcema.

* Za konec bom pripravil še shiny aplikacijo, kjer bomo za vsako leto posebej opazovali gibanje števila izdanih gradbenih dovoljenj v primerjavi s skupno površino teh stanovanj.

### Tabele

1. [gradbena.dovoljenja.letno](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/1970716S.px/) - podatki o izdanih gradbenih dovoljenjih po statističnih regijah
  - `StatisticnaRegija` - spremenljivka: ime statistične regije (character),
  - `Leto` - spremenljivka: leto meritve (numeric),
  - `SteviloStavb` - meritev: število stavb za katere je bilo v nekem letu izdano gradbeno dovoljenje (numeric),
  - `Povrsina_m2` -meritev: površina stavb za katere je bilo v nekem letu izdano gradbeno dovoljenje (numeric).

2. [gradbena.dovoljenja.sept](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/1970712S.px) - podatki o izdanih gradbenih dovoljenjih za mesec september
  - `StatisticnaRegija` - spremenljivka: ime statistične regije (neurejen faktor),
  - `VrstaObjekta` - spremenljivka: pove ali je meritev za stanovanske ali nestanovanjske stavbe (neurejen faktor),
  - `SteviloStavb` - meritev: stevilo stavb za katere je bilo izdano gradbeno dovoljenje (število).
  
  3. [gradbeni.stroski](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/1957611S.px/) - letni indeksi gradbenih stroškov
  - `Leto` - spremenljivka: leto meritve (število),
  - `TipStroska` - spremenljivka: pove nam za kateri tip stroška gre (neurejen faktor),
  - `Indeks` - meritev: indeks tega stroška v določenem letu (število).
  
  4. [indeks.cen.arh.proj](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/0427601S.px/) - podatki o ceni storitve arhitekturnega projektiranja
  - `Leto` - spremenljivka: leto meritve (število),
  - `PovprecenIndeks` - meritev: povprečen indeks, izračunan iz četrtletnih (število).
  
  5. [indeks.neto.plac](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/0772610S.px/) - podatki o neto plačah po statističnih regijah letno
  - `StatisticnaRegija` - spremenljivka: ime statistične regije (neurejen faktor),
  - `Leto` - spremenljivka: leto meritve (število),
  - `Indeks` - meritev: indeks neto plače (število).
  
  6. [stanovanja.brez.os.infra](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/0861201S.px/) - podatki o deležih naseljenih stanovanj brez osnovne infrastrukture po statističnih regijah
  - `StatisticnaRegija` - spremenljivka: ime statistične regije (neurejen faktor),
  - `Leto` - spremenljivka:lwto meritve (število),
  - `DelezVOdstotkih` - meritev: delež stanovanj brez osnovne infrastrukture v letu meritve (število).
  
  7. [vrednost.gradb.del](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/1919802S.px/)- podatki o vrednosti opravljenih gradbenih del v posameznem letu (v 1000 EUR)
  - `Leto` - spremenljivka: leto meritve (število),
  - `Vrednost_1000EUR` - meritev: vrednost vseh opravljenih gradbenih del v posameznem letu meritve v Sloveniji (število).
  
  8. [dokoncana.stanovanja.st.in.povrsina](https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/1906910S.px)- podatki o vrednosti opravljenih gradbenih del v posameznem letu (v 1000 EUR)
  - `StatisticnaRegija` - spremenljivka: Regija (neurejen faktor),
  - `Leto` - spremenljivka: leto meritve (število),
  - `StDokoncanihStanovanjNa1000Prebivalcev` - meritev: število vseh dokončanih stanovanj ob koncu leta na 1000 prebivalcev (število).
  - `PovprecnaPovrsina_m2` - meritev: povprečna površina stanovanj v tem letu (število).
  

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `tmap` - za izrisovanje zemljevidov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-202021)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
