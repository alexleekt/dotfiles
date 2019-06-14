#!/bin/bash
# $ ./darksky.sh <config.json>
# Gets the current conditions from the Forecast.io (DarkSky) API
# Pulls the JSON apart using 'jq' and dumps the temperature and
# humidity values out.

#
# Check dependencies
#
if ! command -v curl >/dev/null 2>&1; then
    echo "\"cURL\" is required but not installed; try \"sudo apt-get install curl\" and try again. Abort."
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "\"jq\" is required but not installed; try \"sudo apt-get install jq\" and try again. Abort."
    exit 1
fi

#
# Helper Functions
#
function strip_quotes {
    tmp=$1
    tmp="${tmp%\"}"
    tmp="${tmp#\"}"
    echo $tmp
}

#
# Parse the config file
# {
#     "latitude": <number>, /* 52.205316 */
#     "longitude": <number>, /* 0.121627 */
#     "apiKey": <string>, /* 0123456789abcdef9876543210fedcba */
#     "language": <string>, /* en */
#     "units": <string> /* si */
# }
#
CONFIG_FILE=$1
#echo "Config. File: $CONFIG_FILE"
if [ "$CONFIG_FILE" = "" ]; then
    echo "Configuration file not specified. Abort."
    exit 2
fi
CONFIG=$(cat $CONFIG_FILE)
#echo "Config.: $CONFIG"
LAT=$(echo $CONFIG | jq '.latitude')
LONG=$(echo $CONFIG | jq '.longitude')
#echo "Lat./Long.: $LAT,$LONG"
API_KEY=$(echo $CONFIG | jq '.apiKey')
API_KEY=$(strip_quotes $API_KEY)
#echo "API Key: $API_KEY"
LANG=$(echo $CONFIG | jq '.language')
LANG=$(strip_quotes $LANG)
#echo "Language: $LANG"
UNITS=$(echo $CONFIG | jq '.units')
UNITS=$(strip_quotes $UNITS)
#echo "Units: $UNITS"

#
# Query the API
#
API_URI=https://api.darksky.net/forecast
RSP=`curl -sS "${API_URI}/${API_KEY}/${LAT},${LONG}?lang=${LANG}&units=${UNITS}&exclude=minutely,hourly,daily,alerts"`
#RSP=$(cat response.json)
#echo "Response: $RSP"
#echo $RSP > response.json
CURRENTLY=$(echo $RSP | jq '.currently')
TEMPERATURE=$(echo $CURRENTLY | jq '.temperature')
APPARENTTEMPERATURE=$(echo $CURRENTLY | jq '.apparentTemperature' | awk '{print int($1+0.5)}')
HUMIDITY=$(echo $CURRENTLY | jq '.humidity')
HUMIDITY=$(echo $HUMIDITY*100 | bc)
#echo "Temperature: $TEMPERATURE°C"
#echo "Humidity: $HUMIDITY%RH"
ICON=$(echo $CURRENTLY | jq '.icon') # uses nerd-fonts
case $(strip_quotes $ICON) in
"clear-day")
    ICON=""
    ;;
"clear-night")
    ICON=""
    ;;
"rain")
    ICON=""
    ;;
"snow")q
    ICON=""
    ;;
"sleet")
    ICON=""
    ;;
"wind")
    ICON=""
    ;;
"fog")
    ICON=""
    ;;
"cloudy")
    ICON=""
    ;;
"partly-cloudy-day")
    ICON=""
    ;;
"partly-cloudy-night")
    ICON=""
    ;;
"hail")
    ICON=""
    ;;
"thunderstorm")
    ICON=""
    ;;
"tornado")
    ICON=""
    ;;
esac

echo "$APPARENTTEMPERATURE°C $ICON"
