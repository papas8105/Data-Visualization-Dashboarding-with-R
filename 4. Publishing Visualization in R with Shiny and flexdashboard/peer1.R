library(shiny)
library(tidyverse)

#####Import Data

dat<-read_csv("../Data/cces.csv")
dat<- dat %>% select(c("pid7","ideo5"))
dat<-drop_na(dat)

## Interface

ui <- fluidPage(
  sliderInput(inputId = "ideology",label = "Select Five Point Ideology 
              (1=Very liberal, 5=Very conservative)",min = 1,max = 5,value = 3,step = 1),
  mainPanel(plotOutput("plot",width = "150%"))
)

## Server

server<-function(input,output){
  output$plot <- renderPlot({
    ggplot(data = dat %>% filter(ideo5 == input$ideology)) + 
      geom_bar(aes(x = pid7)) + xlab("7 Point Party ID, 1=Very D,7=very R")} + xlim(c(0,8)) + 
      scale_y_continuous("Count",limits = c(0,125),breaks = seq(0,125,by = 25))
    )}

shinyApp(ui,server)