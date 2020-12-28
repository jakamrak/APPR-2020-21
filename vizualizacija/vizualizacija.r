# 3. faza: Vizualizacija podatkov
library(ggplot2)

source('lib/libraries.r', encoding = 'UTF-8')


#testni graf
graf1 <- vrednost.gradb.del %>% 
  ggplot(aes(x=leto, y=vrednost)) + 
  geom_line(size=1, colour="green") + 
  geom_point(size=2, colour="blue") +
  xlab("leto") +
  ylab("vrednost") +
  labs(title="Vrednost gradbenih del po letih ") 

