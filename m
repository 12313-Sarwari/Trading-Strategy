import numpy as np
import pandas as pd
import datetime as dt
import yfinance as yf

def calculate_emas(df, emas_used):
    """Calculate exponential moving averages for a list of periods."""
    for ema in emas_used:
        df[f"Ema_{ema}"] = df['Adj Close'].ewm(span=ema, adjust=False).mean()
    return df

def trading_strategy(df, emas_short, emas_long):
    """Implement the Red-White-Blue trading strategy."""
    pos = 0
    percentage_change = []

    for i in df.index:
        cmin = min(df[f"Ema_{ema}"][i] for ema in emas_short)
        cmax = max(df[f"Ema_{ema}"][i] for ema in emas_long)
        close = df["Adj Close"][i]

        if cmin > cmax and pos == 0:
            bp = close
            pos = 1
            print(f"Buying now at {bp}")

        elif cmin < cmax and pos == 1:
            pos = 0
            sp = close
            print(f"Selling now at {sp}")
            pc = (sp / bp - 1) * 100
            percentage_change.append(pc)
        
    # If still holding a position at the end, sell it
    if pos == 1:
        sp = df["Adj Close"].iloc[-1]
        pc = (sp / bp - 1) * 100
        percentage_change.append(pc)
        print(f"Selling final position at {sp}")

    return percentage_change

def analyze_trades(percentage_change):
    """Analyze the trade results."""
    gains = sum(x for x in percentage_change if x > 0)
    losses = sum(x for x in percentage_change if x <= 0)
    ng = len([x for x in percentage_change if x > 0])
    nl = len([x for x in percentage_change if x <= 0])
    
    if ng > 0:
        avg_gain = gains / ng
        max_r = max(percentage_change)
    else:
        avg_gain = 0
        max_r = "undefined"

    if nl > 0:
        avg_loss = losses / nl
        max_l = min(percentage_change)
        ratio = -(avg_gain / avg_loss) if avg_loss != 0 else "undefined"
    else:
        avg_loss = 0
        max_l = "undefined"
        ratio = "inf"

    total_return = round((np.prod([(x/100) + 1 for x in percentage_change]) - 1) * 100, 2)
    batting_avg = ng / (ng + nl) if (ng + nl) > 0 else 0

    return {
        "trades": ng + nl,
        "batting_avg": batting_avg,
        "gain_loss_ratio": ratio,
        "average_gain": avg_gain,
        "average_loss": avg_loss,
        "max_return": max_r,
        "max_loss": max_l,
        "total_return": total_return
    }

def main():
    stock = input("Enter a stock ticker symbol: ").upper()

    start = dt.datetime(2019, 1, 1)
    now = dt.datetime.now()

    df = yf.download(stock, start=start, end=now)
    
    # Ensure we have valid data
    if df.empty:
        print("Failed to retrieve data for the given ticker symbol.")
        return
    
    emas_used = [3, 5, 8, 10, 12, 15, 30, 35, 40, 45, 50, 60]
    df = calculate_emas(df, emas_used)

    emas_short = emas_used[:6]  # Short-term EMAs
    emas_long = emas_used[6:]   # Long-term EMAs

    percentage_change = trading_strategy(df, emas_short, emas_long)

    results = analyze_trades(percentage_change)

    print()
    print(f"Results for {stock} from {df.index[0]} to {df.index[-1]}, Sample size: {results['trades']} trades")
    print(f"EMAs used: {emas_used}")
    print(f"Batting Avg: {results['batting_avg']:.2f}")
    print(f"Gain/Loss Ratio: {results['gain_loss_ratio']}")
    print(f"Average Gain: {results['average_gain']:.2f}%")
    print(f"Average Loss: {results['average_loss']:.2f}%")
    print(f"Max Return: {results['max_return']}")
    print(f"Max Loss: {results['max_loss']}")
    print(f"Total Return over {results['trades']} trades: {results['total_return']}%")
    print()

if __name__ == "__main__":
    main()

