#!/bin/bash

# Note: dracal-usb-get assumed to be in the **path**
# Arguments passed to -i (0,1,2) here need to be updated to fit
# your scenario. You may also specify a serial number by adding
# the -s argument.

# If dracal-usb-get exits with a non-zero values, the exit status will be checked.
if ! output=$(dracal-usb-get -i 0,1,2 2>&1); then
  echo "dracal-usb-get error"
  exit 1
fi

fields=$(echo $output | tr "," "\n")

# This example expects the following output:
#
# 100.40, 24.48, 61.56
#
# Where fields are pressure, temperature and rh (humidity).
#
# Detect errors by checking if the exact expected number
# fields was returned.
if [[ $(echo $fields | wc -w) -lt 3 ]]; then
  echo "Error reading sensor"
  exit 2
fi

# Convert the fields from strings to floating point values
# This step is necessary to perform math on values.
pressure=$(echo $fields | awk '{print $1}')
temperature=$(echo $fields | awk '{print $2}')
rh=$(echo $fields | awk '{print $3}')

# Display values
echo "Temperature (C): $temperature"
echo "RH......... (%): $rh"
echo "Pressure..(kPa): $pressure"
echo "Temperature (F): $(echo "scale=2; $temperature*9/5+32" | bc)"
