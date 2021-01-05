# 4. faza: Analiza podatkov

podatki <- gradbeni.stroski %>% filter(TipStroska=="StroskiMateriala") %>%
  select(-"TipStroska")

prileganje <- glm(data = podatki, Indeks ~ Leto)

leta <- data.frame(Leto=seq(2016, 2020, 1))
napoved <- mutate(leta, Indeks=predict(prileganje, leta))

podatki <- podatki %>% rbind(napoved %>% filter(Leto==2020)) #na stare podatke dodamo leto 2020 iz napovedi

graf_regresija <- podatki %>% ggplot(aes(x=Leto, y=Indeks)) + 
  geom_point(aes(color=(Leto == 2020)), size=3) + 
  geom_smooth(method='glm', formula=y ~ poly(x,2,raw=TRUE), fullrange=TRUE, color='darkblue') +
  scale_x_continuous('Leto', breaks = seq(2016, 2020, 1), limits = c(2016,2020)) +
  ylab("Indeks stroškov materiala") +
  labs(title = "Napoved indeksa stroškov materiala za leto 2020") +
  theme(axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(color = "red"), 
        axis.ticks.length = unit(2, "mm")) + 
  guides(color=FALSE)
plot(graf_regresija)
