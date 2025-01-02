#!/bin/bash

# Define thresholds
CPU_THRESHOLD=4
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
EMAIL="prabhatmore@gmail.com"

# Get system metrics
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Check if any threshold is exceeded and send email
if [ $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc) -eq 1 ]; then
  echo "CPU Usage is high: $CPU_USAGE%" | mail -s "High CPU Usage Alert" $EMAIL
fi

if [ $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc) -eq 1 ]; then
  echo "Memory Usage is high: $MEMORY_USAGE%" | mail -s "High Memory Usage Alert" $EMAIL
fi

if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
  echo "Disk Usage is high: $DISK_USAGE%" | mail -s "High Disk Usage Alert" $EMAIL
fi
