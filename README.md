# MSFT-forecast

# About the Project
This project studies Microsoft (MSFT) monthly stock prices using data from Yahoo Finance. The main goal is to compare several forecasting models and find which one gives the most accurate prediction.

The data covers the period from January 2020 to December 2025. Daily stock prices are converted into monthly closing prices so the series is easier to analyze and forecast.

The project first examines the data pattern, including trend, seasonality, and stationarity. Then, the data is split into training and testing sets. Four forecasting models are applied: Holt, Holt-Winters additive, Holt-Winters multiplicative, and ARIMA.

The models are compared using MAE and RMSE. The best model is then used to produce the final 12-month forecast for Microsoft stock prices.

# Team Member
[Nida Faliha](https://github.com/nidafaliha)
[Nabeel Pasha](https://github.com/NabeelPasha)
# The Dataset
Source: Yahoo Finance
Ticker: MSFT
Time period: January 2020 to December 2025
Original frequency: Daily
Converted frequency: Monthly
Variable used: Closing Price
Unit of analysis: Monthly Microsoft stock prices

# Methodology
1. Data Collection
   Download Microsoft (MSFT) stock price data from Yahoo Finance using R.
2. Data Preparation
   Extract the closing price and convert the daily stock data into monthly data.
3. Exploratory Time Series Analysis
   Plot the series and identify trend and seasonality patterns.
4. Stationarity Testing
   Use ndiffs(), nsdiffs(), and KPSS tests to evaluate whether the series is stationary.
5. Train-Test Split
   Split the monthly series into 75% training data and 25% testing data.
6. Forecasting Models
   Apply the following models:
   - Holt’s Method
   - Holt-Winters Additive
   - Holt-Winters Multiplicative
   - ARIMA
7. Model Evaluation
   Compare model performance using:
   - MAE
   - RMSE
8. Final Forecasting:
   Select the best model and generate a 12-month forecast using the full dataset.

# Key Outputs
1. Monthly Microsoft stock price time series plot
2. Trend, seasonality, and stationarity analysis
3. Forecast comparison across Holt, Holt-Winters, and ARIMA
4. Model accuracy table using MAE and RMSE
5. Best model selection
6. Final 12-month Microsoft stock price forecast







