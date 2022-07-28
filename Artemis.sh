#!/bin/bash

clear

# Automated Recon Script because I'm lazy
# Some outputs are in .md to make it easier for us Obsidian users xo
# More features to come
# Created by Lavender-exe

# Banner
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

# Directories

mkdir Scans

# IP Address
echo -n "Please enter an IP Address: "
read IP

# Functions

# ------------- General -------------

nmapRecon() {
	echo "[*] Scanning with Nmap"
	nmap -T4 -A -p- $IP -oN Scans/init-nmap.md -oX Scans/init-nmap.xml -vvv
	sudo nmap -T4 -sC -sV --script vuln $IP -oN Scans/vuln-nmap.md -oX Scans/vuln-nmap.xml -vvv

	echo "[+] Converting XML File(s) into a Readable Form..."
	xsltproc Scans/init-nmap.xml -o Scans/init-nmap.html
	xsltproc Scans/vuln-nmap.xml -o Scans/vuln-nmap.html

	echo "[?] Would you like to scan for UDP? (y/n)"
	read Answer
	if [ "$Answer" == "y" ];
		then
			nmap -sUV -T4 -oN Scans/udp-nmap.md -oX Scans/udp-nmap.xml
			xsltproc Scans/udp-nmap.xml -o Scans/udp-nmap.html
	fi
}


# ------------- Websites -------------

niktoRecon(){
	echo "[*] Scanning with Nikto"
	echo "[?] Custom Port? (y/n) * Default 80 *"
	read Answer
	
	if [ "$Answer" == "y"];
		then
			echo "[!] Enter Port:"
			read PORT
			nikto -h http://$IP:$PORT/ -C ALL
		
		else
			nikto -h http://$IP/ -C ALL
	fi
}

ffufFuzzDomain(){
	echo "[*] Scanning with Ffuf"
	echo "[?] Custom Port? (y/n) * Default 80 *"
	read Answer
	if [ "$Answer" == "y" ];
		then
			echo "[!] Enter Port:"
			read PORT
			
			ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt:FUZZ -u http://$IP:$PORT/FUZZ -v -c --recursion-depth 2 -r -of Scans/ffuf-domain-1.json
			ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt:FUZZ -u http://$IP:$PORT/FUZZ/ -v -c --recursion-depth 2 -r  -of Scans/ffuf-domain-2.json
		
		else
			ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt:FUZZ -u http://$IP/FUZZ -v -c --recursion-depth 2 -r -of Scans/ffuf-domain-1.json
			ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt:FUZZ -u http://$IP/FUZZ/ -v -c --recursion-depth 2 -r  -of Scans/ffuf-domain-2.json
	fi
}

ffufFuzzDNS(){

	echo "[?] Custom Port? (y/n)"
	read Answer
	if [ "$Answer" == "y" ];
		then
			echo "[!] Enter Port:"
			read PORT
 			ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -u http://$IP:$PORT.com/ -H “Host: FUZZ.$IP:$PORT.com” -of Scans/ffuf-dns.json
		
		else
			ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -u http://$IP.com/ -H “Host: FUZZ.$IP.com” -of Scans/ffuf-dns.json
	fi
}

continue(){
	echo ""
	echo "[!] Please press enter to continue..."
	read
	clear
}

badOption(){
	echo "[-] The option you have chosen is not on the list."
	clear
}

goodbye(){
	echo ""
	echo "Until Next Time...👁‍"
}

# ------------- Options -------------

until [ "$Options" == "0" ]; do

	echo ""
	echo "[!!] Please select your Target Type: "
	echo ""
	echo "	[1] Machine/Server	"
	echo "	[2] Website	"
	echo "	[3] DNS	"
	echo ""
	echo "	[0] Exit	"
	echo ""
	read Options
	
	echo ""

# ------------- Option Cases -------------

	case $Options in
		1) clear ; nmapRecon ;;
		2) clear ; nmapRecon ; niktoRecon ; ffufFuzzDomain ;;
		3) clear ; ffufFuzzDNS;;
		0) clear ; goodbye ; exit ;;
		*) clear ; badOption ; continue ;

	esac

done
