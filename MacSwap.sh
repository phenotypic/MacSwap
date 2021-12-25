#! /bin/bash

GREENT='\033[1;32m'
REDT='\033[1;31m'
BLUET='\033[1;34m'
CYAN='\033[0;36m'
DARKGRAY='\033[1;30m'
DUN='\033[1;30;4m'
NC='\033[0m'

OSTYPE="$( uname -s )"
TERMINALCOLOUR="$( defaults read -g AppleInterfaceStyle 2>/dev/null )"

if [[ "$TERMINALCOLOUR" == *"Dark"* ]]; then
  DARKGRAY='\033[1;37m'
  DUN='\033[1;37;4m'
else
  DARKGRAY='\033[1;30m'
  DUN='\033[1;30;4m'
fi

printf "${NC}"

clear
cat << "EOF"

                   __  __             _____
                  |  \/  |           / ____|
                  | \  / | __ _  ___| (_____      ____ _ _ __
                  | |\/| |/ _` |/ __|\___ \ \ /\ / / _` | '_ \
                  | |  | | (_| | (__ ____) \ V  V / (_| | |_) |
                  |_|  |_|\__,_|\___|_____/ \_/\_/ \__,_| .__/
                                                        | |
                                                        |_|

EOF

if [ "$OSTYPE" != "Darwin" ]; then
  printf "\n${REDT}[!] ${NC}ERROR: This script is only designed for macOS...\n"
  exit
fi

WIFIINTERFACENAME="$( networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}' )"
REALMAC="$( networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline;getline; print $3}' )"

sudo -v

CURRENTMAC="$( ifconfig $WIFIINTERFACENAME | awk '/ether/{print $2}' )"

printf "${BLUET}[*] ${NC}Real MAC address:    ${DARKGRAY}$REALMAC${NC}\n"
printf "${BLUET}[*] ${NC}Current MAC address: ${DARKGRAY}$CURRENTMAC${NC}\n"

printf "\n${DUN}Options:${NC}"
printf "\n${DARKGRAY}[1]${NC} Bypass login page"
printf "\n${DARKGRAY}[2]${NC} Bypass restriction"
printf "\n${DARKGRAY}[3]${NC} Random"
printf "\n${DARKGRAY}[4]${NC} Custom"
printf "\n${DARKGRAY}[5]${NC} Reset"

printf "\n\n${GREENT}[+] ${NC}"
read -p "Choose an option (1-5): " CHOSENOPTION

if [[ ! $CHOSENOPTION =~ ^[1-9]+$ ]] || (( $CHOSENOPTION > 5 )); then
  printf "\n${REDT}[!] ${NC}ERROR: Invalid input...\n"
  exit
fi

if [ "$CHOSENOPTION" == "1" ] || [ "$CHOSENOPTION" == "2" ]; then
  WIFISTATUS="$( ifconfig $WIFIINTERFACENAME | grep "status" )"
  if [[ "$WIFISTATUS" == *"inactive"* ]]; then
    printf "\n${REDT}[!] ${NC}ERROR: Connect to a network first...\n"
    exit
  fi

  ARPSCAN="$( arp -ani $WIFIINTERFACENAME | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | grep -E '^.{17}$' | grep -v 'ff:ff:ff:ff' )"
  SCANLENGTH="$( echo "$ARPSCAN" | wc -l | tr -dc '0-9' )"

  if [ -z "$ARPSCAN" ]; then
    printf "${REDT}[!] ${NC}ERROR: Scan failure, run again...\n"
    exit
  elif [ "$SCANLENGTH" -gt "2" ]; then
    HALFLENGTH=$(($SCANLENGTH / 2))
    ARPMAC="$( echo "$ARPSCAN" | sed -n "${HALFLENGTH}p" )"
  elif [ "$SCANLENGTH" == "2" ]; then
    ARPMAC="$( echo "$ARPSCAN" | sed -n '2p' )"
  else
    ARPMAC=$ARPSCAN
  fi
fi

if [ "$CHOSENOPTION" == "2" ]; then
  ARPMAC="$( echo ${ARPMAC/%??/} )"
  RANDNUM="$( openssl rand -hex 1 )"
  ARPMAC+="$RANDNUM"
  if [[ "$ARPSCAN" == *"ARPMAC"* ]]; then
    printf "\n${REDT}[!] ${NC}ERROR: MAC overlap, run again...\n"
    exit
  fi
fi

if [ "$CHOSENOPTION" == "3" ]; then
  ARPMAC="$( openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' )"
fi

if [ "$CHOSENOPTION" == "4" ]; then
  printf "\n${GREENT}[+] ${NC}"
  read -p "Enter MAC address: " ARPMAC
fi

if [ "$CHOSENOPTION" == "5" ]; then
  if [ "$REALMAC" == "$CURRENTMAC" ]; then
    printf "\n${GREENT}[*] ${NC}MAC address already reset...\n"
    echo
    exit
  fi
  ARPMAC="$REALMAC"
fi

ARPMAC="$( echo "$ARPMAC" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' )"
ARPMACLENGTH=${#ARPMAC}

if [ "$ARPMACLENGTH" != "17" ]; then
  printf "\n${REDT}[!] ${NC}ERROR: Invalid MAC address...\n"
  exit
fi

printf "\n${BLUET}[*] ${NC}Changing MAC address from ${DARKGRAY}$CURRENTMAC${NC} to ${DARKGRAY}$ARPMAC${NC}\n"

sudo ifconfig $WIFIINTERFACENAME up
sudo ifconfig $WIFIINTERFACENAME ether $ARPMAC && sleep 0.5 && sudo ifconfig $WIFIINTERFACENAME down && sleep 1 && sudo ifconfig $WIFIINTERFACENAME up

NEWMAC="$( ifconfig $WIFIINTERFACENAME | awk '/ether/{print $2}' )"

if [ "$CURRENTMAC" == "$NEWMAC" ]; then
  printf "\n${REDT}[!] ${NC}ERROR: No change to MAC address...\n"
  exit
fi

if [ "$NEWMAC" == "$ARPMAC" ]; then
  printf "\n${GREENT}[*] ${NC}Successfully changed MAC address!\n"
  echo
  exit
else
  printf "\n${REDT}[!] ${NC}ERROR: Failed to change MAC address...\n"
  exit
fi
