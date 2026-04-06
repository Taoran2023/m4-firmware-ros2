#!/bin/bash

# Copy rules file to location
cp ./11-local.rules /etc/udev/rules.d/

# Activate the rules
chmod 644 /etc/udev/rules.d/11-local.rules
udevadm control --reload-rules
udevadm trigger
