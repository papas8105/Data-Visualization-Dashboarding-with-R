library(shiny)
library(tidyverse)
library(plotly)
library(DT)

#####Import Data

dat<-read_csv("../Data/cces.csv")
dat<- dat %>% select(c("pid7","ideo5","newsint","gender","educ","CC18_308a","region"))
dat<-drop_na(dat)

#####Make your app

ui <- navbarPage(title = "My Application",
  tabPanel("Page 1",sidebarPanel(
  sliderInput(inputId = "ideology",label = "Select Five Point Ideology 
              (1=Very liberal, 5=Very conservative)",min = 1,max = 5,value = 3,step = 1)
  ),
  mainPanel(
    tabsetPanel(tabPanel("Tab 1",plotOutput("plot1")),
                tabPanel("Tab 2",plotOutput("plot2")))
  )),
  tabPanel("Page 2",sidebarPanel(
    checkboxGroupInput("sexbox","Select Gender",choices = c(1,2))
  ),
  mainPanel(plotlyOutput("plot3"))),
  tabPanel("Page 3",
           sidebarPanel(selectInput(
             "region","Select Region",as.character(c(1,2,3,4)),multiple = TRUE)),
           mainPanel(DTOutput("datatable",width = "100%"))
  ))



server <- function(input,output) {
  output$plot1 <- renderPlot({
    ggplot(data = dat %>% filter(ideo5 == input$ideology)) + 
      geom_bar(aes(x = pid7)) + xlab("7 Point Party ID, 1=Very D,7=very R") + xlim(c(0,8)) + 
      scale_y_continuous("Count",limits = c(0,125),breaks = seq(0,105,by = 25))
  })
  
  output$plot2 <- renderPlot({
    ggplot(data = dat %>% filter(ideo5 == input$ideology)) + 
      geom_bar(aes(x = CC18_308a)) + xlab("Trump Support") +  xlim(c(0,5))
  })
  
  output$plot3 <- renderPlotly({
    dat %>%
      filter(gender %in% input$sexbox) %>%
      ggplot(mapping = aes(x = pid7, y = educ)) +
      geom_jitter() +
      geom_smooth(method = lm,formula = "y ~ x") -> g
    ggplotly(p = g)
  })
  
  output$datatable <- renderDT(
    dat %>% filter(region %in% input$region)
  )
}

shinyApp(ui,server)