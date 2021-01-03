# 4. faza: Analiza podatkov

podatki <- gradbeni.stroski %>% filter(TipStroska=="StroskiMateriala") %>%
  select(-"TipStroska")


prileganje <- lm(data = podatki, Indeks ~ Leto)

l <- data.frame(Leto=seq(2016, 2020, 1))
napoved <- mutate(l, Indeks=predict(prileganje, l))


graf_regresija <- ggplot(podatki, aes(x=Leto, y=Indeks)) + 
  geom_point(size=3, color="red") + 
  geom_smooth(method='lm', formula=y ~ poly(x,2,raw=TRUE), fullrange=TRUE, color='darkblue') +
  scale_x_continuous('Leto', breaks = seq(2016, 2020, 1), limits = c(2016,2020)) +
  ylab("Indeks stroškov materiala") +
  labs(title = "Napoved indeksa stroškov materiala za leto 2020")
  

