# 3. faza: Vizualizacija podatkov

##1
#PRIPRAVIM TABELO ZA RISANJE TORTNEGA DIAGRAMA

tortni <- gradb.dovoljenja.sept %>%
  mutate(delezi=100*SkupajObjekti / sum(SkupajObjekti)) %>%
  arrange(desc(StatisticnaRegija)) %>%
  mutate(lab.ypos=cumsum(delezi) - 0.5*delezi)

#Tortni diagram gradbenih dovoljenj za september 2020

graf_tortni <- ggplot(tortni) +
  aes(x="", y=delezi, fill=StatisticnaRegija) +
  geom_col(width=1, color="white") +
  coord_polar(theta="y") + xlab("") + ylab("") +
  geom_text(aes(y=lab.ypos, label=paste0(round(delezi, 2), "%")),
            x=1.3, color="white", size=2.5) +
  labs(title="Deleži izdanih gradbenih dovoljenj po regijah v mesecu septembru leta 2020") +
  guides(fill=guide_legend("Statistična regija")) +
  theme_void()


##2
#Linijski grafikon gradbenih stroškov

graf_stroski <- gradbeni.stroski %>%
  ggplot(aes(x=Leto, y=Indeks, col=TipStroska)) +
  geom_line()+
  geom_point(size=2)+
  labs(title="Indeksi gradbenih stroškov")+
  #guides(fill=guide_legend("Tip stroška"))+
  scale_x_continuous(name = "Leto", breaks = seq(2010,2019,1))+
  scale_y_continuous(name = "Indeks", breaks = seq(90,120,2))+
  theme(legend.title = element_text(color = "darkblue", size = 10),
        axis.line = element_line(colour = "darkblue", 
                                 size = 1, linetype = "solid"),
        legend.background = element_rect(fill = "lightblue", linetype="solid", 
                                         colour ="darkblue"),
        legend.position = c(0.3, 0.8),
        panel.grid.minor = element_blank())+
  scale_color_discrete(name="Tip stroška",
                       labels=c("SkupajStroski"="Skupaj stroški",
                                "StroskiDela"="Stroški dela",
                                "StroskiMateriala"="Stroški materiala"))



##3
#PRIPRAVIM TABELO ZA RISANJE TOČKOVNEGA GRAFA 

infra.in.place <- indeks.neto.plac %>%
  right_join(stanovanja.brez.os.infra, by = c("StatisticnaRegija", "Leto"))


#Točkovni grafikon primerjave indeksa plac z deležem naseljenih stanovanja brez
#osnovne infrastrukture po regijah

graf_infra.in.place <- infra.in.place %>%
  ggplot(aes(x=Indeks, y=DelezVOdstotkih)) +
  geom_point(aes(color=StatisticnaRegija), size=2) +
  xlab("Indeks neto plač") +
  scale_y_continuous(name="Delež stanovanj [%]", breaks=seq(2, 10, 1)) +
  labs(title="Delež naseljenih stanovanj brez osnovne infrastrukture in indeks neto plač") +
  guides(color=guide_legend("Statistična regija")) +
  facet_grid(. ~ Leto) +
  geom_smooth(method="lm", se=FALSE) + #podatki so razprseni a vidi se da pri nizji 
  theme(panel.grid.minor = element_blank())                               #placi je delež stanovanj brez osnovne infra vecji in obratno
 
##4
#PRIPRAVIM TABELO ZA RISANJE 

gradb.dela.in.arh.proj <- indeks.cen.arh.proj %>% 
  right_join(vrednost.gradb.del, by = "Leto") 

# diagram, ki kaže povezanost vrednosti opravljenih gradb del in cen arhitekturnega projektiranja
 
graf_gradb.dela.in.arh.proj <- gradb.dela.in.arh.proj %>% ggplot(aes(x=Leto)) +
  geom_line(aes(y=PovprecenIndeks), size = 1, color="red") +
  scale_x_continuous(breaks=seq(2010, 2018, 1)) +
  scale_y_continuous(breaks=seq(0, 150, 25), 
                     sec.axis = sec_axis(~.*17000, name = "Vrednost gradbenih del [1000EUR]"))+
  geom_col(aes(y = Vrednost_1000EUR/17000), size = 1, col="darkblue", fill="white", alpha=I(0)) +
  xlab("Leto") + ylab("Indeks cen arhitekturnega projektiranja") +
  labs(title="Primerjava indeksa cen arhitekturnega projektiranja in vrednosti 
       opravljenih gradbenih del") +
  theme_classic() +
  theme(axis.title.y.left = element_text(color="red", margin = margin(r = .3, unit = "cm")),
        axis.title.y.right = element_text(color="darkblue", margin = margin(l = .3, unit = "cm")), 
        axis.text.y.right = element_text(angle = 15)) 
  
  
  
##5
#ZEMLJEVID

#pripravimo podatke za zemljevid
Slovenija <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1", encoding="UTF-8") %>% fortify()
colnames(Slovenija)[12]<-'StatisticnaRegija'  #preimenujemo stolpec
Slovenija$StatisticnaRegija <- gsub('Notranjsko-kraška', 'Primorsko-notranjska', Slovenija$StatisticnaRegija)
Slovenija$StatisticnaRegija <- gsub('Spodnjeposavska', 'Posavska', Slovenija$StatisticnaRegija)
#zamenjali smo stara imena s pravimi



#tabela za leto 2011 in 2018
stanovanja.brez.os.infra.2011.in.2018 <- filter(stanovanja.brez.os.infra, Leto==2011| Leto==2018)

#zemljevid 
zemljevid.stanovanja.brez.os.infra.2011.in.2018 <- ggplot() +
  geom_polygon(data = right_join(stanovanja.brez.os.infra.2011.in.2018, Slovenija, by = "StatisticnaRegija"),
               aes(x = long, y = lat, group = group, fill = DelezVOdstotkih))+
  ggtitle("Naseljena stanovanja brez osnovne infrastrukture v letu 2011 in 2018") + 
  theme(axis.title=element_blank(), axis.text=element_blank(), 
        axis.ticks=element_blank(), panel.background = element_blank()) +
  scale_fill_gradient(low = '#FCDADA', high='#970303', limits=c(0,10)) +
  labs(fill="Delež po regijah v %") +
  geom_path(data = right_join(stanovanja.brez.os.infra.2011.in.2018, Slovenija,
                              by = "StatisticnaRegija"), aes(x = long, y = lat, 
                                                             group = group), 
            color = "white", size = 0.1) +
  facet_grid(. ~ Leto) 




