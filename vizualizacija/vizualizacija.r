# 3. faza: Vizualizacija podatkov

source('lib/libraries.r', encoding = 'UTF-8')
source("uvoz/uvoz.r", encoding = 'UTF-8')


#testni
graf1 <- vrednost.gradb.del %>% 
  ggplot(aes(x=Leto, y=Vrednost_1000EUR)) + 
  geom_line(size=1, colour="green") + 
  geom_point(size=2, colour="blue") +
  xlab("leto") +
  ylab("vrednost") +
  labs(title="Vrednost gradbenih del po letih ") +
  stat_smooth(method = "lm")


##1
#PRIPRAVIM TABELO ZA RISANJE TORTNEGA DIAGRAMA

tortni <- gradb.dovoljenja.sept %>% 
  mutate(delezi = round(100*(gradb.dovoljenja.sept$SkupajObjekti) / 
                          sum(gradb.dovoljenja.sept$SkupajObjekti), digits = 2)) %>%
  arrange(desc(StatisticnaRegija)) %>%
  mutate(lab.ypos = cumsum(delezi) - 0.5*delezi)

#Tortni diagram gradbenih dovoljenj za september

graf_tortni <- ggplot(tortni) +
  aes(x="", y=delezi, fill=StatisticnaRegija) +
  geom_col(width=1) +
  coord_polar(theta="y") + xlab("") + ylab("") +
  geom_text(aes(y = lab.ypos, label = paste(delezi, "%", sep="")), color = "white", size = 2.5)+
  labs(title="Deleži izdanih gradbenih dovoljenj po regijah v mesecu septembru")+
  guides(fill=guide_legend("Statistična regija"))

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
  scale_fill_discrete(name = "Tip stroška", labels = 
                        c("Skupaj stroki", "Stroški dela", "Stroški materiala"))  #s tem sem zelel preimenovati elemente legende a ne dela


##3
#PRIPRAVIM TABELO ZA RISANJE TOČKOVNEGA GRAFA 

infra.in.place <- indeks.neto.plac %>%
  right_join(stanovanja.brez.os.infra, by = c("StatisticnaRegija", "Leto"))


#Točkovni grafikon primerjave indeksa plac z deležem naseljenih stanovanja brez
#osnovne infrastrukture po regijah

graf_infra.in.place <- infra.in.place %>%
  ggplot(aes(x=Indeks, y=DelezVOdstotkih, col=StatisticnaRegija))+
  geom_point(size=2)+
  xlab("Indeks neto plač")+
  ylab("Delež stanovanj")+
  scale_y_continuous(name = "Delež stanovanj [%]", breaks = seq(2,10,1))+
  labs(title="Delež naseljenih stanovanj brez osnovne infrastrukture in indeks neto plač")+
  guides(fill=guide_legend("Statistična regija"))+ #Ne dela!
  facet_grid(.~Leto)
  #stat_smooth(method = "lm")
  
  

 
