
import pandas as pd
import matplotlib.pyplot as plt


df = pd.read_csv('path_to_file.csv')

# Group the data by 'LastMkt' and plot histograms
for name, group in df.groupby('LastMkt'):
    plt.figure()  # Create a new figure for each histogram
    group['LatencyNs'].plot(kind='hist', bins=50, title=f'Histogram of LatencyNs for {name}')
    plt.xlabel('LatencyNs')
    plt.ylabel('Frequency')
    plt.grid(True)
    plt.show()
