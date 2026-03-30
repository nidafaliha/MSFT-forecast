# GROUP FINAL PROJECT
# Forecasting Microsoft (MSFT) Monthly Stock Prices
# Using Holt's Method and ARIMA in R

# Load packages
library(quantmod)
library(forecast)
library(Metrics)
library(urca)
library(lmtest)
library(tseries)
library(xts)

# Download data 
msft_data = getSymbols("MSFT",src = "yahoo",from = "2020-01-01",to = "2025-12-31",auto.assign = FALSE)
head(msft_data)
msft_close = msft_data[, "MSFT.Close"]

# Convert daily data to monthly data
msft_monthly <- to.monthly(msft_close, indexAt = "lastof", OHLC = FALSE)

# Convert to time series object
msft_ts <- ts(as.numeric(msft_monthly),start = c(2020, 1),frequency = 12)

# Plot the monthly series
plot(msft_ts, type = "l", col = "blue",main = "Microsoft (MSFT) Monthly Close Price",xlab = "Year", ylab = "Price")

# Identify patterns
# Trend and seasonality check
ndiffs(msft_ts)     # number of differences needed for trend stationarity
nsdiffs(msft_ts)    # seasonal differences needed

# ndiffs = 1 -> has trend
# nsdiffs = 0 -> no seasonality

# Stationarity test using KPSS
summary(ur.kpss(msft_ts)) 
# KPSS test statistic = 1.6495 > cr(5%) = 0.463 : Microsoft monthly close price is non-stationary

# First difference of log series
dlog_msft <- diff(log(msft_ts))
summary(ur.kpss(dlog_msft))
# KPSS test statistic = 0.0708 < cr(5%) = 0.463 : the differenced log series is stationary

# Split into training and test set (75% train, 25% test)
n = length(msft_ts)
train_size = floor(0.75 * n)
h = n - train_size

train_ts <- window(msft_ts, end = time(msft_ts)[train_size])
test_ts  <- window(msft_ts, start = time(msft_ts)[train_size + 1])

length(train_ts)
length(test_ts)

# Model 1: Holt's method
holt_model = holt(train_ts, h = h)

# Plot Holt forecast vs actual
plot(holt_model, main = "Holt Forecast vs Actual")
lines(test_ts, col = "red")

# Model 2: ARIMA
arima_model <- auto.arima(train_ts)
summary(arima_model)
# The selected model is ARIMA(0,1,0) with drift -> 

# Significance of coefficients
coeftest(arima_model)
# Since the p-value (0.03726) < 0.05, the drift term is significant. 
# This suggests an average upward movement in Microsoft’s stock price over time.

# Forecast ARIMA
arima_forecast <- forecast(arima_model, h = h)

# Plot ARIMA forecast vs actual
plot(arima_forecast, main = "ARIMA Forecast vs Actual")
lines(test_ts, col = "red")

# Accuracy comparison
holt_mae  <- mae(as.numeric(test_ts), as.numeric(holt_model$mean))
holt_rmse <- rmse(as.numeric(test_ts), as.numeric(holt_model$mean))
# Smaller MAE and RMSE values indicate better forecast accuracy. Holt performs fairly well.

arima_mae  <- mae(as.numeric(test_ts), as.numeric(arima_forecast$mean))
arima_rmse <- rmse(as.numeric(test_ts), as.numeric(arima_forecast$mean))
# ARIMA also performs reasonably well, but it is slightly less accurate than Holt on this test set.

# Additional Exponential Smoothing Models
hw_add_model <- hw(train_ts, h = h, seasonal = "additive")
hw_mult_model <- hw(train_ts, h = h, seasonal = "multiplicative")

# Accuracy for Holt-Winters additive
hw_add_mae  <- mae(as.numeric(test_ts), as.numeric(hw_add_model$mean))
hw_add_rmse <- rmse(as.numeric(test_ts), as.numeric(hw_add_model$mean))
# The additive model gives the largest errors, so it performs worst among the compared models.

# Accuracy for Holt-Winters multiplicative
hw_mult_mae  <- mae(as.numeric(test_ts), as.numeric(hw_mult_model$mean))
hw_mult_rmse <- rmse(as.numeric(test_ts), as.numeric(hw_mult_model$mean))

# Updated results table
results <- data.frame(
  Model = c("Holt", "HW_Additive", "HW_Multiplicative", "ARIMA"),
  MAE = c(holt_mae, hw_add_mae, hw_mult_mae, arima_mae),
  RMSE = c(holt_rmse, hw_add_rmse, hw_mult_rmse, arima_rmse))

print(results)

# Select best model
best_model <- results$Model[which.min(results$RMSE)]
print(best_model)


# Residual diagnostics
checkresiduals(holt_model)
checkresiduals(arima_model)

# Refit best model on full sample and forecast next 12 months
if (best_model == "Holt") {
  final_model <- holt(msft_ts, h = 12)
  plot(final_model, main = "Final 12-Month Forecast Using Holt")
} else {
  final_model <- forecast(auto.arima(msft_ts), h = 12)
  plot(final_model, main = "Final 12-Month Forecast Using ARIMA")
}

# Print forecast values
print(final_model$mean)

#result: 
# 1. Microsoft’s monthly stock price shows an upward trend.
# 2. The data does not show strong seasonality, the original series is not stationary.
# 3. After first differencing the log series, the data becomes stationary.
# 4. Four models were compared: Holt, Holt-Winters Additive, Holt-Winters Multiplicative, and ARIMA.
# 5. Holt gave the lowest RMSE, so it is the best model.
# 6. The final forecast suggests that Microsoft’s stock price may keep increasing during 2026.
