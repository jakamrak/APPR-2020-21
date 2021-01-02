# 3. faza: Vizualizacija podatkov

source('lib/libraries.r', encoding = 'UTF-8')
source("uvoz/uvoz.r", encoding = 'UTF-8')



##1
#PRIPRAVIM TABELO ZA RISANJE TORTNEGA DIAGRAMA

tortni <- gradb.dovoljenja.sept %>%
  mutate(delezi=100*SkupajObjekti / sum(SkupajObjekti)) %>%
  arrange(desc(StatisticnaRegija)) %>%
  mutate(lab.ypos=cumsum(delezi) - 0.5*delezi)

#Tortni diagram gradbenih dovoljenj za september

graf_tortni <- ggplot(tortni) +
  aes(x="", y=delezi, fill=StatisticnaRegija) +
  geom_col(width=1) +
  coord_polar(theta="y") + xlab("") + ylab("") +
  geom_text(aes(y=lab.ypos, label=paste0(round(delezi, 2), "%")),
            x=1.3, color="white", size=2.5) +
  labs(title="Deleži izdanih gradbenih dovoljenj po regijah v mesecu septembru") +
  guides(fill=guide_legend("Statistična regija")) +
  theme(axis.text=element_blank())



##2
#Linijski grafikon gradbenih stroškov

graf_stroski <- gradbeni.stroski %>%
  ggplot(aes(x=Leto, y=Indeks, col=TipStroska)) +
  geom_line()+
  geom_point(size=2)+
  labs(title="Indeksi gradbenih stroškov")+
  #guides(fill=guide_legend("Tip stroška"))+
  xlab("Leto")+
  ylab("Indeks")+
  scale_x_continuous(name = "Leto", breaks = seq(2010,2019,1))+
  scale_y_continuous(name = "Indeks", breaks = seq(90,120,2))+
  theme(legend.title = element_text(color = "red", size = 10),
        legend.background = element_rect(fill = "darkgray"))+
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
  ylab("Delež stanovanj") +
  scale_y_continuous(name="Delež stanovanj [%]", breaks=seq(2, 10, 1)) +
  labs(title="Delež naseljenih stanovanj brez osnovne infrastrukture in indeks neto plač") +
  guides(color=guide_legend("Statistična regija")) +
  facet_grid(. ~ Leto) +
  geom_smooth(method="lm", se=FALSE)  #podatki so razprseni a vidi se da pri nizji 
                                      #placi je delež stanovanj brez osnovne infra vecji in obratno
  

##4
#PRIPRAVIM TABELO ZA RISANJE 

gradb.dela.in.arh.proj <- indeks.cen.arh.proj %>% 
  right_join(vrednost.gradb.del, by = "Leto") 
  #pivot_longer(2:3,names_to = "TipMeritve",values_to = "Meritev")

#Stolpcini diagram, ki kaže povezanost vrednosti opravljenih gradb del in cen arhitekturnega projektiranja

#graf_gradb.dela.in.arh.proj <- gradb.dela.in.arh.proj %>%
#  ggplot(aes(x=Leto, fill=TipMeritve)) +
#  geom_line(aes(y=PovprecenIndeks))
#plot(graf_gradb.dela.in.arh.proj)
#
ggplot(gradb.dela.in.arh.proj, aes(x = Leto)) + 
  geom_col(aes(y = PovprecenIndeks), size = 1) +
  geom_line(aes(y= Vrednost_1000EUR), size = 1, color="red") +
  scale_x_continuous(breaks=seq(2010, 2018, 1)) +
  scale_y_continuous(sec.axis = sec_axis(~./15000, name = "Indeks cen arhitekturnega projektiranja"))+
  xlab("Leto") +
  ylab("Vrednost [1000EUR]")



ggplot(gradb.dela.in.arh.proj, aes(x=Vrednost_1000EUR, y=PovprecenIndeks, shape=Leto))+
  geom_point(size=2)+ 
  geom_smooth(method="lm")+
  xlab("Vrednost opravljenih gradbenih del [1000EUR]") +
  ylab("Indeks cen arhitekturnega projektiranja")



  
