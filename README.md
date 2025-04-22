#    **Credit Card Fraud Detection Using Machine Learning - Shiny App**

This Shiny web application predicts the likelihood of a credit card transaction being fraudulent based on various transaction features. The app uses a Random Forest classifier, trained on a balanced dataset using the ROSE (Random Over-Sampling Examples) method, to make predictions.

Features:
Prediction Section: Users can input transaction details such as distance from home, transaction history, and whether the transaction was online or used a chip. The model will predict if the transaction is fraudulent or legitimate.
Data View: Displays a sample of the credit card transaction dataset with details about various transactions.
Insights: Visualizes trends in the data with interactive plots:
Fraud vs Legitimate Transactions: A bar chart showing the count of fraudulent and legitimate transactions.
Online vs Offline Fraud: A comparison of fraudulent transactions in online vs offline purchases.
Chip Usage in Fraud: Analyzes the role of chip usage in fraudulent transactions.
Purchase Price Ratio by Fraud Type: Box plot to visualize how the purchase price ratio varies between fraudulent and legitimate transactions.

Technologies Used:
R Programming: For data manipulation, modeling, and creating visualizations.
Shiny: To build the interactive web interface.
Random Forest: A machine learning algorithm used for fraud detection.
ROSE Package: To balance the dataset by generating synthetic data for underrepresented classes.
ggplot2: For data visualizations.
