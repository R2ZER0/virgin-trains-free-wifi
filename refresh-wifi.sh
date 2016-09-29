#!/bin/bash

WIFI_ID="VirginTrainsEC-WiFi"
COOKIE_JAR="/tmp/vtec-cookies.txt"

# First disconnect the wifi
nmcli connection down id "$WIFI_ID"

# Set the MAC to a random one
RAND_MAC_1="00"
RAND_MAC_5=$(dd bs=1 count=5 if=/dev/random 2>/dev/null | hexdump -v -e '/1 "-%02X"')
RAND_MAC="${RAND_MAC_1}${RAND_MAC_5}"

echo "Setting cloned mac to $RAND_MAC"

nmcli connection modify id "$WIFI_ID" 802-11-wireless.cloned-mac-address "$RAND_MAC"

# Connect again to WiFi
nmcli connection up id "$WIFI_ID"

sleep 0.5

RAND_NAME_1=$(dd bs=1 count=10 if=/dev/random 2>/dev/null | hexdump -v -e '/1 "%02X"')
RAND_NAME_2=$(dd bs=1 count=10 if=/dev/random 2>/dev/null | hexdump -v -e '/1 "%02X"')
RAND_EMAIL="${RAND_NAME_1}@${RAND_NAME_2}.com"

echo "Using random email $RAND_EMAIL"

echo "Post registration form..."
curl --cookie-jar $COOKIE_JAR --data "title=Mr&forename=${RAND_NAME_1}&surname=${RAND_NAME_2}&email=${RAND_EMAIL}&repeat_email=${RAND_EMAIL}&nearest_station=897600&mobile_phone=&offers_email=false&head_code=" http://virgintrainseastcoast.on.icomera.com/api/register.php

echo "Get hotspot classcheck(?)..."
curl --cookie $COOKIE_JAR "https://www.ombord.info/hotspot/hotspot.cgi?method=classcheck&redirecturl=http://virgintrainseastcoast.on.icomera.com/&url=http://virgintrainseastcoast.on.icomera.com/&onerror=http://virgintrainseastcoast.on.icomera.com/"

echo "Post free 15 mins form..."
curl --cookie $COOKIE_JAR --data "method=login&realm=ecml_15min_free&password=&url=http://virgintrainseastcoast.on.icomera.com/index.html&onerror=http://virgintrainseastcoast.on.icomera.com/index.html" https://www.ombord.info/hotspot/hotspot.cgi

rm --preserve-root -I $COOKIE_JAR

echo "Done!"
