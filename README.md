# 💳 Credit Card Fraud Detection Using Machine Learning (Shiny App)

This repository contains an interactive Shiny web application that predicts whether a credit card transaction is **fraudulent** or **legitimate** using a **Random Forest** classifier. The app also provides visual insights from the dataset to help understand fraud patterns.

---

## 🚀 Features

### 🔍 Prediction
- Input transaction details like:
  - Distance from Home
  - Distance from Last Transaction
  - Ratio to Median Purchase Price
  - Repeat Retailer
  - Used Chip
  - Used PIN Number
  - Online Order
- Click “Predict Fraud” to get a prediction result.

### 📄 Data View
- Displays a sample of the credit card transactions (first 100 rows).

### 📊 Insights
- **Fraud vs Legitimate Transactions**
- **Online vs Offline Fraud**
- **Chip Usage in Fraud**
- **Purchase Price Ratio by Fraud Type**

---

## 🧠 Machine Learning

- **Model**: Random Forest
- **Data Balancing**: ROSE (Random Over Sampling Examples)
- **Target Variable**: `fraud` (0 = Legitimate, 1 = Fraudulent)
- **Training**: Performed on a balanced dataset to improve fraud detection accuracy.

---

## 🛠️ Technologies Used

- `R`
- `Shiny` & `shinydashboard` – For building the UI
- `randomForest` – Machine learning model
- `ROSE` – Dataset balancing
- `ggplot2` – Data visualizations
- `DT` – Interactive data table

---

## 📁 Dataset

The dataset used (`card_transaction.csv`) contains transaction details with features such as:
- Distance from home
- Distance from last transaction
- Purchase price ratio
- Online order status
- PIN and chip usage

Make sure the dataset is placed in the root directory of the project.

---

## ▶️ Run Locally

To run the app locally:

```r
# Install required packages if not already installed
install.packages(c("shiny", "shinydashboard", "ggplot2", "DT", "randomForest", "ROSE"))

# Run the app
shiny::runApp()
