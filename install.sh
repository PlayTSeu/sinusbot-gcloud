#!/bin/bash
# SinusBot by PlayTS.eu - najwyższa jakość dźwięku tylko u nas
# https://PlayTS.eu
#------# CONFIG #------#
FOLDER="PlayTS-SinusBot";
SINUSBOT="https://www.sinusbot.com/dl/sinusbot.current.tar.bz2";
TS3VERSION="3.3.2";
#----------------------#
mkdir $FOLDER; cd $FOLDER;

#Podstawowe funkcje do wypisywania tekstu
function greenMessage() {
  echo -e "\\033[32;1m${*}\\033[0m"
}
function redMessage() {
  echo -e "\\033[31;1m${*}\\033[0m"
}

#Instalacja wymaganych pakietów
greenMessage "Usuwam zbędne komunikaty od Google Cloud Shell";
mkdir $HOME/.cloudshell;
touch $HOME/.cloudshell/no-apt-get-warning;
touch $HOME/.cloudshell/no-python-warning;
greenMessage "Instaluję wymagane pakiety przez SinusBota";
sudo apt-get update;
sudo apt-get install -y x11vnc xvfb libxcursor1 ca-certificates bzip2 libnss3 libegl1-mesa x11-xkb-utils libasound2 libpci3 libxslt1.1 libxkbcommon0 libxss1 curl libglib2.0-0 ffmpeg;

#Instalacja aplikacji SinusBot
greenMessage "Pobieram aplikację SinusBot";
wget $SINUSBOT;
mv sinusbot-1.0.0-beta.8-9e95ca7.tar.bz2 sinusbot.current.tar.bz2;
greenMessage "Wypakowuję aplikację SinusBot";
tar -xjf sinusbot.current.tar.bz2;
rm sinusbot.current.tar.bz2;

#Konfiguracja podstawowa SinusBota
greenMessage "Konfiguruję aplikację SinusBot";
cp config.ini.dist config.ini;
sed -i "s:/opt/sinusbot:$HOME/$FOLDER:g" config.ini;
rm config.ini.dist;
chmod +x "./sinusbot";

#Instalacja youtube-dl do odtwarzania filmów z YouTube
greenMessage "Pobieram aplikację YouTube-DL do odtwarzania filmów z YouTube";
wget "https://yt-dl.org/downloads/latest/youtube-dl";
chmod a+rx youtube-dl;
echo "YoutubeDLPath = \"$HOME/$FOLDER/youtube-dl\"" >>config.ini

#Instalacja klienta TeamSpeak
greenMessage "Pobieram klienta TeamSpeak";
wget "https://files.teamspeak-services.com/releases/client/$TS3VERSION/TeamSpeak3-Client-linux_amd64-$TS3VERSION.run";
chmod +x "TeamSpeak3-Client-linux_amd64-$TS3VERSION.run";
redMessage "Teraz poproszę Ciebie o akceptację licencji aplikacji TeamSpeak";
redMessage "Proszę kliknij Enter następnie literę Q potem Y i Enter, by zaakceptować licencję firmy TeamSpeak GmbH";
./TeamSpeak3-Client-linux_amd64-$TS3VERSION.run;
rm TeamSpeak3-Client-linux_amd64-$TS3VERSION.run;
greenMessage "Konfiguruję klienta TeamSpeak";
mkdir TeamSpeak3-Client-linux_amd64/plugins/;
cp plugin/libsoundbot_plugin.so TeamSpeak3-Client-linux_amd64/plugins/;

#Skrypty startowe
greenMessage "Tworzę polecenie ./start.sh do uruchamiania aplikacji";
echo "sudo apt-get install -y libxss1 libpci3 libegl1-mesa"$'\n'"./$FOLDER/sinusbot" >$HOME/start.sh;
chmod +x $HOME/start.sh;

#Pierwsze uruchomienie
greenMessage "Wykonuję pierwsze uruchomienie SinusBota. Zapisz hasło i zaloguj się klikając w adres http://0.0.0.0:8087";
./sinusbot;
