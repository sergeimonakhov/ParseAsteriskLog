#!/bin/bash
echo "Недозвон" > /tmp/1
echo "Ошибка набора номера" > /tmp/2
while read month day year not chan call from tel_n ip to extension to_tel
do
	DATEM=$(echo $month $day) 
	if [[ $to_tel =~ ^9810[0-9]{3}.*$ ]] || [[ $to_tel =~ ^98[0-9]{10}$ ]] || [[ $to_tel =~ ^[2-7][0-9]{2,3}$ ]] || [[ $to_tel =~ ^9[0-9]{7}$ ]]; then
		if [[ $DATEM == $(date "+%b %d" -d "yesterday") ]]; then
			echo -e $month $day $year from:$tel_n to:$to_tel"\n" >> /tmp/1
		fi
	else
		if [[ $DATEM == $(date "+%b %d" -d "yesterday") ]]; then
			echo -e $month $day $year from:$tel_n to:$to_tel"\n" >> /tmp/2
		fi
	fi
done < <(cat /var/log/asterisk/full | grep "rejected because" | sed "s/'//g;s/rejected.*//;s/\[//g;s/\]//g")
cat /tmp/2 >> /tmp/1
cat /tmp/1 | /bin/mail -s "Statistics on calls" "admin@example.com"