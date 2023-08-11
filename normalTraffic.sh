#!/bin/bash

# Ping parameters
source_ip="10.0.0.2"   # Source IP address (h1's IP)
ping_count=100         # Number of ping packets to send
destination_ips=(      # List of destination IPs (h2 to h18 IPs)
    "10.0.0.3"
    "10.0.0.4"
    "10.0.0.5"
    "10.0.0.17"
)

# Load the trained model using Keras
model_path='ddos_detection_model/ddos_detection_model.h5'
python3 - <<END
import pandas as pd
import numpy as np
from keras.models import load_model

# Load the dataset
data = pd.read_csv('ddos_detection_model/dataset_noraml.csv')  # Replace 'your_dataset.csv' with your dataset filename

# Extract the columns needed for prediction
features_cols = ['pktcount', 'bytecount', 'dur', 'dur_nsec', 'tot_dur', 'flows', 'packetins', 'pktperflow']
ping_data = data.loc[data['src'] == '$source_ip', features_cols].values

# Load the trained model
model = load_model('$model_path')

# Perform DDoS detection
predictions = model.predict(ping_data)
ddos_detected = any(pred > 0.5 for pred in predictions)

if ddos_detected:
    print("DDoS detected from $source_ip to $ip")
else:
    print("No DDoS detected from $source_ip to $ip")
END
