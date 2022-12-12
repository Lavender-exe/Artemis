#!/bin/bash

clear

# Automated Recon Script because I'm lazy
# Some outputs are in .md to make it easier for us Obsidian users xo
# More features to come
# Created by Lavender-exe

# Directories

echo "[+] Creating Directories..."

if [ ! -d "Scans" ]; then
	echo "[+] Scans"
	mkdir Scans
	sleep 1
fi

if [ ! -d "Scans/nmap" ]; then
	echo "[+] Scans/nmap"
	mkdir Scans/nmap
	sleep 1
fi

if [ ! -d "Scans/ffuf" ]; then
	echo "[+] Scans/ffuf"
	mkdir Scans/ffuf
	sleep 1
fi


if [ ! -d "Scans/nikto" ]; then
	echo "[+] Scans/nikto"
	mkdir Scans/nikto
	sleep 1
fi


# if [ ! -d "Scans/amass" ]; then
# 	echo "[+] Scans/amass"
# 	mkdir Scans/amass
# fi

echo "[!] Complete"

sleep 1
# Banner

clear
echo "


                                                                               
        ##                                                                     
     /####                                                    #                
    /  ###                       #                           ###               
       /##                      ##                            #                
      /  ##                     ##                                             
      /  ##     ###  /###     ######## /##  ### /### /###   ###        /###    
     /    ##     ###/ #### / ######## / ###  ##/ ###/ /##  / ###      / #### / 
     /    ##      ##   ###/     ##   /   ###  ##  ###/ ###/   ##     ##  ###/  			
    /      ##     ##            ##  ##    ### ##   ##   ##    ##    ####       
    /########     ##            ##  ########  ##   ##   ##    ##      ###      
   /        ##    ##            ##  #######   ##   ##   ##    ##        ###    
   #        ##    ##            ##  ##        ##   ##   ##    ##          ###  
  /####      ##   ##            ##  ####    / ##   ##   ##    ##     /###  ##  
 /   ####    ## / ###           ##   ######/  ###  ###  ###   ### / / #### /   
/     ##      #/   ###           ##   #####    ###  ###  ###   ##/     ###/    
#                                                                              
 ##                                                                            
                                                                                                                                                             

"

echo " "
echo " "

echo "[!!] This program will utilise sudo for some of the commands."

echo " "
echo " "

# IP Address or Website (Add this kthx)
echo -n "Please enter an IP Address: "
read IP

# Functions

# ------------- Declared -------------

continue(){
	echo ""
	echo "[!] Please press enter to continue..."
	read
	clear
}

help_usage(){
	echo " Usage: Artemis (-h | --help
						   -i | --ip
						   -p | --port
						   -u | --url
						   -w | --wordlist)
	"
}

badOption(){
	echo "[-] The option you have chosen is not on the list."
}

goodbye(){
	echo ""
	echo "Until Next Time...👁‍"
}

default_fuzz(){
	WORDLIST='/usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt'
}

default_dns(){
	WORDLIST='/usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt'
}

# ------------- General -------------

nmapRecon() {
	echo "[*] Scanning with Nmap"
	echo " "
	
	nmap -T4 -A -p- $IP -oN Scans/nmap/init-nmap.md -oX Scans/nmap/init-nmap.xml -vvv
	echo ""

	sudo nmap -T4 -sC -sV --script vuln $IP -oN Scans/nmap/vuln-nmap.md -oX Scans/nmap/vuln-nmap.xml -vvv
	echo ""

sleep 1

	echo "[+] Converting XML File(s) into a Readable Form..."
	xsltproc Scans/nmap/init-nmap.xml -o Scans/nmap/init-nmap.html
	xsltproc Scans/nmap/vuln-nmap.xml -o Scans/nmap/vuln-nmap.html
	echo ""

sleep 1

	echo "[?] Would you like to scan for UDP? (y/n)"
	read Answer
	if [ "$Answer" == "y" ];
	then
		sudo nmap -sUV -T4 -oN Scans/nmap/udp-nmap.md -oX Scans/nmap/udp-nmap.xml
		xsltproc Scans/nmap/udp-nmap.xml -o Scans/nmap/udp-nmap.html
	fi

	echo "[*] View logs in: Scans/nmap/"
	sleep 5
}


# ------------- Websites -------------

niktoRecon(){
	clear

	echo "[*] Scanning with Nikto"
	echo " "

	echo "[?] Custom Port? (y/n) * Default 80 *"
	read Answer
	
	if [ "$Answer" == "y" ];
		then
			echo "[!] Enter Port:"
			read PORT

			nikto -h http://$IP:$PORT/ -C ALL >> Scans/nikto/nikto.md 
		
		else
			nikto -h http://$IP/ -C ALL >> Scans/nikto/nikto.md
	fi
	echo "[*] View logs in: Scans/nikto/"
	sleep 5
}

ffufFuzzDomain(){
	clear

	echo "[*] Scanning Directories with Ffuf"
	echo " "
	echo "[+] Please enter a wordlist:"
	read WORDLIST
	echo "[?] Custom Port? (y/n) * Default 80 *"
	read Answer
	if [ "$Answer" == "y" ];
		then
			echo "[!] Enter Port:"
			read PORT
			
			ffuf -w $WORDLIST:FUZZ -u http://$IP:$PORT/FUZZ -v -c --recursion-depth 2 -r -e .aspx,.html,.php,.txt >> Scans/ffuf/ffuf-domain-1.txt
			ffuf -w $WORDLIST:FUZZ -u http://$IP:$PORT/FUZZ/ -v -c --recursion-depth 2 -r -e .aspx,.html,.php,.txt >> Scans/ffuf/ffuf-domain-2.txt
			echo "[*] View logs in: Scans/ffuf/"
			sleep 5
		else
			ffuf -w $WORDLIST:FUZZ -u http://$IP/FUZZ -v -c --recursion-depth 2 -r -e .aspx,.html,.php,.txt >> Scans/ffuf/ffuf-domain-1.txt
			ffuf -w $WORDLIST:FUZZ -u http://$IP/FUZZ/ -v -c --recursion-depth 2 -r   -e .aspx,.html,.php,.txt >> Scans/ffuf/ffuf-domain-2.txt
	fi
}

ffufFuzzDNS(){
	clear

	echo "[*] Scanning DNS with Ffuf"
	echo " "
	
		echo "[+] Please enter a wordlist:"
	read WORDLIST
		echo "[!] Enter URL: (Example: hackthebox.com)" 
	read URL
		echo "[!] Enter Port: (Example: '8080' Default '80')"
	read PORT

	echo " "

 	ffuf -w $WORDLIST -u http://$URL:$PORT -H 'Host: FUZZ.$URL' -c >> Scans/ffuf/ffuf-dns.txt
	echo "[*] View logs in: Scans/ffuf/"
	sleep 5
}

# dnsEnumeration(){
# 	echo "[*] Bruteforcing DNS with Amass"
# 	echo " "

# 	echo "[!] Enter URL: (Example: hackthebox.com)" 
# 	read URL

# 	echo "[!] Enter Port: (Example: '80,8080,443' Default 443)"
# 	read PORT

# 	amass enum -active -brute -d $URL -p $PORT -v -oA Scans/amass/dns_brute
# }

# domainEnumeration(){
# 	echo "[*] Discovering Domains with Amass"
# 	echo " "

# 	echo "[!] Enter URL: (Example: hackthebox.com)" 
# 	read URL

	# echo "[!] Enter Port: (Example: '80,8080,443' Default 443)"
	# read PORT

# 	amass intel -whois -d $URL -v -oA Scans/amass/domains_scan
# }

# ------------- Options -------------

until [ "$Options" == "0" ]; do

	echo ""
	echo "[!!] Please select your Target Type: "
	echo ""
	echo "	[1] Machine/Server	"
	echo "	[2] Website	"
	echo "	[3] Network Scanning with Nmap	"
	echo "	[4] Directory Fuzzing with Ffuf	"
	echo "	[5] DNS Enumeration with Ffuf	"
	# echo "	[5] DNS Enumeration with Amass	"
	echo ""
	echo "	[0] Exit	"
	echo ""
	read Options
	
	echo ""

# ------------- Option Cases - list -------------
# if [ ! $1 ]
	case $Options in
		1) clear ; nmapRecon ;;
		2) clear ; nmapRecon ; niktoRecon ; ffufFuzzDomain ; ffufFuzzDNS;; #dnsEnumeration ; domainEnumeration ;;
		3) clear ; nmapRecon ;;
		4) clear ; ffufFuzzDomain ;;
		5) clear ; ffufFuzzDNS;;
		# 5) clear ; dnsEnumeration;;
		0) clear ; goodbye ; exit ;;
		*) clear ; badOption ; continue ;

	esac
done
# ------------- Option Cases - flags -------------

#while getopts 'wpu:i' flag; do
#  case "${flag}" in
#    -i | --ip) IP=$1 ;;
#    -w | --wordlist) WORDLIST=$2 ;;
#    -p | --port) $PORT=$3 ;;
#    -u | --url) $URL=$4 ;;
#	-h | --help) help_usage;;
#    *) error "Unexpected option ${flag}" ;;
#  esac
#done
