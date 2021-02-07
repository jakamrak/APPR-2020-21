# 4. faza: Analiza podatkov

podatki <- gradbeni.stroski %>% filter(TipStroska=="StroskiMateriala", Leto >= 2016) %>%
  select(-"TipStroska") 



prileganje <- glm(data = podatki, Indeks ~ I(Leto) + I(Leto^2))
leta <- data.frame(Leto = 2020)
napoved <- leta %>% mutate(Indeks=predict(prileganje,.))
podatki <- podatki %>% rbind(napoved) #na stare podatke dodamo leto 2020 iz napovedi

graf_regresija <- podatki %>% ggplot(aes(x=Leto, y=Indeks)) + 
  geom_point(size=3) + 
  geom_smooth(method='glm', formula=y ~ poly(x,2), color='darkblue') +
  geom_point(data = napoved, aes(x = Leto, y = Indeks), color = "red", size = 3)+
  scale_x_continuous('Leto', breaks = seq(2016, 2020, 1), limits = c(2016,2020)) +
  ylab("Indeks stroškov materiala") +
  labs(title = "Napoved indeksa stroškov materiala za leto 2020") +
  theme(axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(color = "red"), 
        axis.ticks.length = unit(2, "mm")) + 
  guides(color=FALSE) #dam stran legendo

graf_regresija

#METODA VODITELJEV

#pripravim posamezne tabele povprecji po regijah
povprecna.dokoncana <- dokoncana.stanovanja.st.in.povrsina %>% 
  group_by(StatisticnaRegija) %>%
  summarise(PovprecnoSteviloZgrajenih = mean(StDokoncanihStanovanjNa1000Prebivalcev), 
            PovrpecnaVelikostZgrajena_m2=mean(PovprecnaPovrsina_m2))

povprecna.gradbena.dovoljenja <- gradbena.dovoljenja.letno %>% 
  group_by(StatisticnaRegija) %>%
  summarise(PovprecnoSteviloGradbenih = mean(SteviloStavb), 
            PovprecnaPovrsinaGradbena_m2 = mean(Povrsina_1000m2))

povprecen.indeks.plac <- indeks.neto.plac %>% 
  group_by(StatisticnaRegija) %>%
  summarise(PovprecenIndeksPlac = mean(Indeks))

povprecen.os.infra <- stanovanja.brez.os.infra %>% 
  group_by(StatisticnaRegija) %>%
  summarise(PovprecenDelezInfra = mean(DelezVOdstotkih))

#skupna tabela povprecji po regijah
povprecna.regije <- povprecna.dokoncana %>%
  left_join(povprecna.gradbena.dovoljenja, by="StatisticnaRegija") %>%
  left_join(povprecen.indeks.plac, by ="StatisticnaRegija") %>%
  left_join(povprecen.os.infra, by = "StatisticnaRegija")


#tema za zemljevid
theme_map <-theme_minimal() +
    theme(
      plot.background = element_rect(fill = "#f5f5f2", color = NA), 
      panel.background = element_rect(fill = "#f5f5f2", color = NA), 
      axis.title=element_blank(), 
      axis.text=element_blank(), 
      axis.ticks=element_blank(), 
      panel.grid.major = element_line(color = "#ebebe5", size = 0.2)
    )



#modelacija podatkov
data.norm <- povprecna.regije %>% .[c(2,3,4,5,6,7)] %>% scale() #normalizirani podatki
rownames(data.norm) <- povprecna.regije$StatisticnaRegija

k <- kmeans(data.norm, 5, nstart=1000) #v koliko skupin jih damo

skupine <- data.frame(StatisticnaRegija=povprecna.regije$StatisticnaRegija,
                      skupina=factor(k$cluster))

#narisemo zemljevid
map.data <- right_join(skupine, Slovenija, by = "StatisticnaRegija")
zemljevid.napredna.analiza <- ggplot(map.data) + 
  geom_polygon(aes(x = long, y = lat, group = group, fill = skupina)) +
  geom_path(aes(x = long, y = lat, group = group), 
            color = "white", size = 0.1) +
  labs(fill="Skupine regij", title="Gručenje regij s podobnimi lastnostmi") +
  scale_fill_brewer(palette="Paired") +
  theme_map 




