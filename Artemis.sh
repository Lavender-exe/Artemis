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
	mkdir Scans/nmap
	nmap -T4 -A -p- $IP -oN Scans/nmap/init-nmap.md -oX Scans/nmap/init-nmap.xml -vvv
	echo ""

	sudo nmap -T4 -sC -sV --script vuln $IP -oN Scans/nmap/vuln-nmap.md -oX Scans/nmap/vuln-nmap.xml -vvv
	echo ""

	echo "[+] Converting XML File(s) into a Readable Form..."
	xsltproc Scans/nmap/init-nmap.xml -o Scans/nmap/init-nmap.html
	xsltproc Scans/nmap/vuln-nmap.xml -o Scans/nmap/vuln-nmap.html
	echo ""
	
	echo "[?] Would you like to scan for UDP? (y/n)"
	read Answer
	if [ "$Answer" == "y" ];
		then
			nmap -sUV -T4 -oN Scans/nmap/udp-nmap.md -oX Scans/nmap/udp-nmap.xml
			xsltproc Scans/nmap/udp-nmap.xml -o Scans/nmap/udp-nmap.html
	fi
}


# ------------- Websites -------------

niktoRecon(){
	clear
	mkdir Scans/nikto
	echo "[*] Scanning with Nikto"
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
}

ffufFuzzDomain(){
	clear
	mkdir Scans/ffuf

	echo "[*] Scanning Directories with Ffuf"
	echo "[?] Custom Port? (y/n) * Default 80 *"
	read Answer
	if [ "$Answer" == "y" ];
		then
			echo "[!] Enter Port:"
			read PORT
			
			ffuf -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt:FUZZ -u http://$IP:$PORT/FUZZ -v -c --recursion-depth 2 -r -o Scans/ffuf/ffuf-domain-1.json -e .aspx,.html,.php,.txt
			ffuf -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt:FUZZ -u http://$IP:$PORT/FUZZ/ -v -c --recursion-depth 2 -r -o Scans/ffuf/ffuf-domain-2.json -e .aspx,.html,.php,.txt
		
		else
			ffuf -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt:FUZZ -u http://$IP/FUZZ -v -c --recursion-depth 2 -r -o Scans/ffuf/ffuf-domain-1.json -e .aspx,.html,.php,.txt
			ffuf -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt:FUZZ -u http://$IP/FUZZ/ -v -c --recursion-depth 2 -r  -o Scans/ffuf/ffuf-domain-2.json -e .aspx,.html,.php,.txt
	fi
}

ffufFuzzDNS(){
	clear
	echo "[*] Scanning DNS with Ffuf"
	echo "[?] Custom Port? (y/n)"
	read Answer
	if [ "$Answer" == "y" ];
		then
			echo "[!] Enter Port:"
			read PORT
 			ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt:FUZZ -u http://$IP:$PORT.com/ -H “Host: FUZZ.$IP.com” -c -o Scans/ffuf/ffuf-dns.txt
		
		else
			ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt:FUZZ -u http://$IP.com/ -H “Host: FUZZ.$IP.com” -c -o Scans/ffuf/ffuf-dns.txt
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
	echo "	[3] Directory Fuzzing with Ffuf	"	
	echo "	[4] DNS Enumeration with Ffuf	"
	echo ""
	echo "	[0] Exit	"
	echo ""
	read Options
	
	echo ""

# ------------- Option Cases -------------

	case $Options in
		1) clear ; nmapRecon ;;
		2) clear ; nmapRecon ; niktoRecon ; ffufFuzzDomain ; ffufFuzzDNS ;;
		3) clear ; ffufFuzzDomain ;;
		4) clear ; ffufFuzzDNS;;
		0) clear ; goodbye ; exit ;;
		*) clear ; badOption ; continue ;

	esac

done
