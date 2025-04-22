library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(randomForest)
library(ROSE)

cc_data <- read.csv("card_transaction.csv")
cc_data$fraud <- as.factor(cc_data$fraud)

balanced_data <- ROSE(fraud ~ ., data = cc_data, seed = 123)$data

set.seed(42)
rf_model <- randomForest(fraud ~ ., data = balanced_data, ntree = 100)

ui <- dashboardPage(
  dashboardHeader(title = "💳 Credit Card Fraud Detection"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Prediction", tabName = "predict", icon = icon("search")),
      menuItem("Data View", tabName = "data", icon = icon("table")),
      menuItem("Insights", tabName = "insight", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML(".box { font-size: 16px; }"))),
    tabItems(
      
      tabItem(tabName = "predict",
              fluidRow(
                column(width = 7,
                       box(title = "🔍 Enter Transaction Details", status = "primary", solidHeader = TRUE, width = 12,
                           numericInput("distance_home", "Distance from Home:", value = 10),
                           numericInput("distance_last", "Distance from Last Transaction:", value = 1),
                           numericInput("ratio_price", "Ratio to Median Purchase Price:", value = 1),
                           selectInput("repeat_retailer", "Repeat Retailer:", choices = c(0, 1)),
                           selectInput("used_chip", "Used Chip:", choices = c(0, 1)),
                           selectInput("used_pin", "Used PIN Number:", choices = c(0, 1)),
                           selectInput("online_order", "Online Order:", choices = c(0, 1)),
                           actionButton("predict_btn", "Predict Fraud", icon = icon("play"), class = "btn-success")
                       )
                ),
                column(width = 5,
                       box(title = "📢 Prediction Result", status = "success", solidHeader = TRUE, width = 12,
                           textOutput("prediction_result"), height = "150px")
                )
              )
      ),
      
      tabItem(tabName = "data",
              fluidRow(
                box(title = "📄 Sample of Credit Card Transactions", width = 12, solidHeader = TRUE, status = "info",
                    dataTableOutput("transaction_table"))
              )
      ),
      
      tabItem(tabName = "insight",
              fluidRow(
                box(title = "📊 Fraud vs Legitimate Transactions", status = "warning", solidHeader = TRUE,
                    plotOutput("fraud_plot", height = "250px"))
              ),
              fluidRow(
                box(title = "🌐 Online vs Offline Fraud", status = "danger", solidHeader = TRUE,
                    plotOutput("online_fraud_plot", height = "250px")),
                box(title = "💾 Fraud Based on Chip Usage", status = "info", solidHeader = TRUE,
                    plotOutput("chip_fraud_plot", height = "250px"))
              ),
              fluidRow(
                box(title = "📈 Purchase Price Ratio by Fraud Type", status = "primary", solidHeader = TRUE,
                    plotOutput("ratio_boxplot", height = "300px"))
              )
      )
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$predict_btn, {
    new_data <- data.frame(
      distance_from_home = input$distance_home,
      distance_from_last_transaction = input$distance_last,
      ratio_to_median_purchase_price = input$ratio_price,
      repeat_retailer = as.numeric(input$repeat_retailer),
      used_chip = as.numeric(input$used_chip),
      used_pin_number = as.numeric(input$used_pin),
      online_order = as.numeric(input$online_order)
    )
    
    prediction <- predict(rf_model, new_data)
    
    output$prediction_result <- renderText({
      if (prediction == 1) {
        "⚠️ This transaction is predicted to be FRAUDULENT!"
      } else {
        "✅ This transaction is predicted to be LEGITIMATE."
      }
    })
  })
  
  # Data View
  output$transaction_table <- renderDataTable({
    datatable(
      head(cc_data, 100),
      options = list(scrollX = TRUE)
    )
  })
  
  # Insights
  output$fraud_plot <- renderPlot({
    ggplot(cc_data, aes(x = fraud, fill = fraud)) +
      geom_bar(width = 0.5) +
      scale_fill_manual(values = c("green3", "red")) +
      labs(title = "Fraud vs Legitimate Transactions",
           x = "Transaction Type", y = "Count") +
      theme_minimal(base_size = 15)
  })
  
  output$online_fraud_plot <- renderPlot({
    ggplot(cc_data, aes(x = factor(online_order), fill = fraud)) +
      geom_bar(position = "dodge") +
      scale_x_discrete(labels = c("Offline", "Online")) +
      scale_fill_manual(values = c("green3", "red")) +
      labs(title = "Online vs Offline Fraud", x = "Order Type", y = "Count") +
      theme_minimal(base_size = 14)
  })
  
  output$chip_fraud_plot <- renderPlot({
    ggplot(cc_data, aes(x = factor(used_chip), fill = fraud)) +
      geom_bar(position = "dodge") +
      scale_x_discrete(labels = c("No Chip", "Used Chip")) +
      scale_fill_manual(values = c("green3", "red")) +
      labs(title = "Chip Usage in Fraud", x = "Chip Usage", y = "Count") +
      theme_minimal(base_size = 14)
  })
  
  output$ratio_boxplot <- renderPlot({
    ggplot(cc_data, aes(x = fraud, y = ratio_to_median_purchase_price, fill = fraud)) +
      geom_boxplot() +
      scale_fill_manual(values = c("green3", "red")) +
      labs(title = "Purchase Ratio by Fraud Type",
           x = "Fraud", y = "Ratio to Median Purchase Price") +
      theme_minimal(base_size = 14)
  })
}

# Run App
shinyApp(ui = ui, server = server)
