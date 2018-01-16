#!/bin/bash
#set -x
#########################################
# Deleting certificate on puppet server #
#########################################
tempfile=$(mktemp /tmp/Erase.XXXX)
puppethub="wkse10m1xpuppethub01.wok1.egalacoral.com"
echo "Do you want to delete the puppet certificate for $1?"
read answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
	HOST=$(host -TtA $1 |grep "has address"|awk '{print $1}')
	DOMAIN=$(dig $HOST|grep -A1 "AUTHORITY SECTION"|tail -n1|sed "s/\(\.\+\)[[:space:]]\+.*/\1/"|sed s/\.$//)
	HOSTN=$(echo ${HOST%.$DOMAIN})
        echo -e "\nPlease select the environment: for $HOST"
        select input in "gdc_prod" "gdc_dev" "gib_prod" "gib_dev" "lab"; do
        case $input in
                 gdc_prod)
			 real="gdc_prod"
                         break
                         ;;
                 gdc_dev)
			 real="gdc_dev"
                         break
                         ;;
                 gib_prod)
			 real="gib_prod"
                         break
                         ;;
                 gib_dev)
			 real="gib_dev"
		
                         break
                         ;;
		 lab)
			 real="lab"
                         break
                         ;;
                 *)
                         echo "Please select a valid option!"
                         ;;
        esac
        done
	ssh -q -t $puppethub "sudo /opt/puppethub/bin/delete_node -e $real -n $HOST -y -d"
fi

