#!/usr/bin/env sh
apt-get install unzip wget git

wget https://github.com/roller-project/roller/releases/download/1.2.1/geth-linux-amd64.zip
unzip ./geth-linux-amd64.zip
mv ./geth-linux-amd64/geth-linux-amd64 /usr/sbin/geth
wget https://raw.githubusercontent.com/roller-project/masternode/master/tools.sh
echo '=========================='
echo 'Configuring service...'
echo '=========================='

cat > /tmp/masternode.service << EOL
[Unit]
Description=Roller Client -- masternode service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=30s
ExecStart=/usr/sbin/geth --masternode --rpcport 8545 --rpcvhosts *
[Install]
WantedBy=default.target
EOL

fi

        sudo \mv /tmp/masternode.service /etc/systemd/system
        sudo systemctl enable masternode && systemctl start masternode
        systemctl status masternode --no-pager --full
else
    echo 'systemd service will not be created.'
fi

echo 'Done.'
