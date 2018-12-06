#!/bin/sh
if [ ! -f /etc/reTurn/configured ]
then
    if [ -n "$IP_ADDRESS" ]
    then
        echo "TurnAddress = "$IP_ADDRESS >> /etc/reTurn/reTurnServer.config;
    else
        echo "No IP_ADDRESS env variable set, ONLY STUN WILL WORK. Please set IP_ADDRESS to one of your local IPs and run again with the '--network host' parameter"
        echo "TurnAddress = 0.0.0.0" >> /etc/reTurn/reTurnServer.config
    fi

    if [ -n "$RETURN_USERNAME" ] 
    then        
            if [ -z "$RETURN_PASSWORD" ] 
            then
                    RETURN_PASSWORD=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo ''`
                    echo "No RETURN_PASSWORD env variable set, generated a random one: "$RETURN_PASSWORD
            fi
    else
        RETURN_PASSWORD=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo ''`
        RETURN_USERNAME="stunturn"
        echo "No RETURN_USERNAME env variable set, user will be set to 'stunturn' and password will be randomly generated"
    fi
    echo "Setting first time configuration as done... "
    touch /etc/reTurn/configured
fi

echo $RETURN_USERNAME":"$RETURN_PASSWORD":reTurn:AUTHORIZED" >> /etc/reTurn/users.txt
echo "Created reTurn user '"$RETURN_USERNAME"' with password '"$RETURN_PASSWORD"'. Please use said credentials into your application"
echo "Executing reTurn daemon... "
exec /usr/sbin/reTurnServer /etc/reTurn/reTurnServer.config --PidFile=/var/run/reTurnServer/reTurnServer.pid