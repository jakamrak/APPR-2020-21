

shinyServer(function(input, output) {
  output$prvigraf <- renderPlot({
    podatki <- gradbena.dovoljenja.letno %>% filter(Leto==input$leto) 
    print( ggplot(podatki) +
             aes(x = SteviloStavb, y=Povrsina_1000m2, col=StatisticnaRegija) + 
             geom_point(size=4) +
             xlab("Število stavb") +
             ylab("Površina stavb [1000 m^2]") +
             labs(title="Površina in število stavb za katere so bila izdana gradbena dovoljenja")) +
             guides(color=guide_legend("Statistična regija")) +
             scale_x_continuous(breaks = seq(0, 1000, by=100), limits = c(0,1000)) +
             scale_y_continuous(breaks = seq(0, 600, by =100), limits = c(0, 600)) +
             theme_classic()
      })
  
  #stolpci so stevilo stanovanj linijski pa povrsina
  output$drugigraf <- renderPlot({
    podatki1 <- dokoncana.stanovanja.st.in.povrsina %>% filter(StatisticnaRegija==input$regija)
    print(ggplot(podatki1, aes(x=Leto))) +
      geom_line(aes(y=PovprecnaPovrsina_m2), size=1, color="royalblue") +
      scale_x_continuous(breaks=seq(2010, 2019, 1)) +
      scale_y_continuous(breaks = seq(25, 250, 25), limits=c(0, 260), 
                         sec.axis = sec_axis(~./50, name = "Število dokončanih stanovanj na 1000 prebivalcev")) +
      geom_col(aes(y=StDokoncanihStanovanjNa1000Prebivalcev*50), size=1, col="tomato4", alpha=I(0)) +
      xlab("Leto") + ylab("Povprečna površina [m^2]") +
      labs(title = "Primerjava velikosti stanovanj in njihovega števila") +
      theme_classic() +
      theme(axis.title.y.left = element_text(color="royalblue"),
            axis.title.y.right = element_text(color="tomato4"))
            
    
  })
})


