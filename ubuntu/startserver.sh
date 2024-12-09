

#!/bin/bash

# Default value for start flag
START_SERVICE=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --start)
      START_SERVICE="$2"  # Get the value after --start
      shift 2             # Skip this argument and its value
      ;;
    --help)
      echo "Usage: $0 [--start true|false]"
      echo "Options:"
      echo "  --start true    Start the service after installation"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      echo "Use --help for usage information."
      exit 1
      ;;
  esac
done

sudo apt update
sudo apt install curl wget unzip grep screen openssl -y
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb -O libssl1.1.deb
sudo dpkg -i libssl1.1.deb
rm libssl1.1.deb
sudo mkdir -p /home/$USER/minecraft_bedrock
DOWNLOAD_URL=$(curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -s -L -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" https://minecraft.net/en-us/download/server/bedrock/ |  grep -o 'https.*/bin-linux/.*.zip')
sudo wget -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" $DOWNLOAD_URL -O /home/mcserver/minecraft_bedrock/bedrock-server.zip
sudo unzip /home/mcserver/minecraft_bedrock/bedrock-server.zip -d /home/mcserver/minecraft_bedrock/
sudo rm /home/mcserver/minecraft_bedrock/bedrock-server.zip
sudo chown -R $USER: /home/mcserver/


if [ "$START_SERVICE" == "true" ]; then
echo "starting the server, to stop it, type stop and hit enter. for a comprehensive guide on servers, check out https://github.com/Judah/-Faison/mcserver/ubuntu/README.md"
  cd /home/$USER/minecraft_bedrock/
  sudo LD_LIBRARY_PATH=. ./bedrock_server
else
  echo "Skipping service start. Do you want to edit the server? Run sudo nano /home/$USER/minecraft_bedrock/server.properties
theres a ton of options available"
fi

echo "Setup completed!"
