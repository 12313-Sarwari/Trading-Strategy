Stock Trading Strategy Simulation

Description
This project simulates a trading strategy based on multiple Exponential Moving Averages (EMAs) over historical stock data. The strategy is often referred to as the "Red-White-Blue" strategy, which attempts to identify buy and sell signals based on the crossover of short-term and long-term EMAs.

Features
Downloads historical stock data using the Yahoo Finance API.
Calculates EMAs for various periods.
Implements a trading strategy based on the relationship between short-term and long-term EMAs.
Analyzes trade results to calculate metrics like batting average, gain/loss ratio, average gain/loss, and total return.
Outputs a summary of the trading performance.


Here's an example of what the output might look like:

Enter a stock ticker symbol: AAPL
Downloading data...

Results for AAPL from 2019-01-02 to 2023-08-24, Sample size: 20 trades
EMAs used: [3, 5, 8, 10, 12, 15, 30, 35, 40, 45, 50, 60]
Batting Avg: 0.70
Gain/Loss Ratio: 2.5
Average Gain: 3.45%
Average Loss: -1.38%
Max Return: 12.8%
Max Loss: -5.3%
Total Return over 20 trades: 45.67%
