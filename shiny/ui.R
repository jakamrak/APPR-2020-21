

shinyUI(
  fluidPage(
    theme = shinytheme("superhero"),
    navbarPage("Analiza gradnje in gradbenih dovoljenj",
               tabPanel("Gradbena dovoljenja",
                        titlePanel(title=h2("Primerjava površine in števil stavb za katere so bila izdana gradbema dovoljenja", align="center")),
                        sidebarLayout(
                        sidebarPanel(
                          sliderInput(inputId = "leto",
                                      label = "Leto",
                                      min = 2010,
                                      max = 2019,
                                      value = 2010, 
                                      step = 1)
                        ), #konec prvega sidebar panel
                        mainPanel(
                          plotOutput(outputId = "prvigraf"))
                        )), #konec prvega tab panela
               
               tabPanel("Dokončana stanovanja",
                        titlePanel(title = h2("Primerjava števila dokončanih stanovanj na 1000 prebivalcev z njihovo povprečno površino", align="center")),
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(inputId = "regija",
                                        label = "Statistična regija",
                                        choices = c(sort(unique(dokoncana.stanovanja.st.in.povrsina$StatisticnaRegija)))),
                            p("Stolpični diagram kaže število stanovanj na 1000 prebivalcev ob koncu leta, linijski grafikon pa povprečno površino le-teh.")
                            
                          ), #konec drugega sidebar panel
                          mainPanel(
                            plotOutput(outputId = "drugigraf"))
                        )) #konec drugega tab panela
               ) #konec navbarPage
  ) #konec fluid page
) #konec shinyUI
