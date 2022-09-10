#!/usr/bin/env bash
version="0.1.0"

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
    -V | --version )
      echo $version
      exit
      ;;
  esac
  shift
done
if [[ "$1" == "--" ]]; then shift; fi

# merge args for SSIDs with spaces
args="$@"

function yes_or_no {
  while true; do
    read -p "$* [y/N]: " yn
    yn=${yn:-n}  # If "yn" is empty (no user input) default to "n"
    case $yn in
      [Yy]*) return 0 ;;  
      [Nn]*) return 1 ;;
    esac
  done
}

if yes_or_no "Generate image?"; then
  flag_generate_image="yes"
  default_qr_code_path="/tmp/wifi-qr.png"
  read -e -p "Enter the path to save the qr code image file to [${default_qr_code_path}]: " qr_code_path
  qr_code_path=${qr_code_path:-${default_qr_code_path}}
fi

function generate_qr_code {
  qr_text="WIFI:T:WPA;S:${ssid};P:${pwd};;"

  if [ $flag_generate_image == "yes" ]; then
    echo $qr_text | qrencode -o $qr_code_path
  else
    echo $qr_text | qrencode -t UTF8
  fi
}

function linux {
  # check for user-provided ssid 
  if [ "" != "$args" ]; then
    ssid="$args"
    exists="`nmcli -f NAME connection | egrep "${ssid}"`"

    if [[ $exists == "" ]]; then
      echo "ERROR: Could not find SSID \"$ssid\"" >&2
      exit 1
    fi
  else
    # get current ssid
    ssid="`nmcli -t -f in-use,ssid dev wifi | egrep '^\*' | cut -d\: -f2`"
    if [ "$ssid" = "" ]; then
      echo "ERROR: Could not retrieve current SSID. Are you connected?" >&2
      exit 1
    fi
  fi
  
  pwd=$(sudo sed -e '/^psk=/!d' -e 's/psk=//' "/etc/NetworkManager/system-connections/${ssid}")

  if [ "" == "$pwd" ]; then
    echo "ERROR: Could not get password. Did you enter your credentials?" >&2
    exit 1
  fi

  generate_qr_code
}


function mac {
  # locate airport(1)
  airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  if [ ! -f $airport ]; then
    echo "ERROR: Can't find \`airport\` CLI program at \"$airport\"."
    exit 1
  fi

  # check for user-provided ssid 
  if [ "" != "$args" ]; then
    ssid="$@"
  else
    # get current ssid
    ssid="`$airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`"
    if [ "$ssid" = "" ]; then
      echo "ERROR: Could not retrieve current SSID. Are you connected?" >&2
      exit 1
    fi
  fi

  sleep 2
  # source: http://blog.macromates.com/2006/keychain-access-from-shell/
  pwd="`security find-generic-password -ga \"$ssid\" 2>&1 >/dev/null`"

  if [[ $pwd =~ "could" ]]; then
    echo "ERROR: Could not find SSID \"$ssid\"" >&2
    exit 1
  fi

  # clean up password
  pwd=$(echo "$pwd" | sed -e "s/^.*\"\(.*\)\".*$/\1/")

  if [ "" == "$pwd" ]; then
    echo "ERROR: Could not get password. Did you enter your Keychain credentials?" >&2
    exit 1
  fi

  generate_qr_code
}


if [[ "$OSTYPE" == "linux-gnu" ]]; then
  linux 
  exit 0
elif [[ "$OSTYPE" == *"darwin"* ]]; then
  mac
  exit 0
fi

echo "ERROR: Unsupported OS" >&2
exit 1
