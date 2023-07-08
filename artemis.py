#!/usr/bin/env python3

import argparse
import subprocess
import os
from rich.console import Console

console = Console()

def banner():
    console.print("""
          
                                                                               
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
/     ##      #/   ###           ##   #####    ###  ###  ###   ##/     ###/    2.0
#                                                                              
 ##                                                                            
                                                                                                                                                             

          """, style="bold yellow")

def createFolders():
    if not os.path.exists("scans"):
        os.makedirs("scans")
        os.makedirs("scans/nmap")
        os.makedirs("scans/ffuf")
        os.makedirs("scans/ffuf/directory")
        os.makedirs("scans/ffuf/subdomain")
        os.makedirs("scans/ffuf/directory/normal")
        os.makedirs("scans/ffuf/directory/proxy")
        os.makedirs("scans/nikto")
        console.print("[+] Created directories: scans, scans/nmap, scans/ffuf, scans/nikto", style="bold green")

# Nmap
def nmapTcp(target):
    console.print(f"[*] Starting Nmap TCP Scan on {target}", style="bold yellow")
    nmapTcp_cmd = f"nmap -T4 -Pn -n -p- -vvv --min-rate=5000 {target} -oA scans/nmap/nmap-tcp"
    
    try:
        output = subprocess.check_output(nmapTcp_cmd, shell=True)
        console.print(output.decode('utf-8'), style="bold green")
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running nmap: {e}", style="bold red")
        
def nmapUdp(target):
    console.print(f"[*] Starting Nmap UDP Scan on {target}", style="bold yellow")
    nmapUdp_cmd = f"nmap -T4 -Pn -n -p- -vvv --min-rate=5000 {target} -oA scans/nmap/nmap-udp"
    
    try:
        output = subprocess.check_output(nmapUdp_cmd, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running nmap: {e}", style="bold red")

#  Directory Fuzzing
def ffufNormalFuzz(url, wordlist):
    ffufCommand = f"ffuf -w {wordlist} -u {url}FUZZ -c -ac -o ffuf-scan -r --recursion --recursion-depth 2 -od scans/ffuf/directory/normal -of all"
    try:
        output = subprocess.check_output(ffufCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running FFUF: {e}", style="bold red")

def ffufProxyFuzz(url, wordlist, proxy):
    ffufCommand = f"ffuf -w {wordlist} -u {url}FUZZ -x http://{proxy} -c -ac -o ffuf-scan -r --recursion --recursion-depth 2 -od scans/ffuf/directory/proxy -of all"
    try:
        output = subprocess.check_output(ffufCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running FFUF: {e}", style="bold red")

# Subdomain Fuzzing
def ffufSubdomainNormal(url, wordlist):
    ffufCommand = f"ffuf -w {wordlist} -H 'Host: FUZZ.{url}' -u {url} -c -ac -o ffuf-scan -r --recursion --recursion-depth 2 -od scans/ffuf/subdoman/normal -of all"
    try:
        output = subprocess.check_output(ffufCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running FFUF: {e}", style="bold red")
        
def ffufSubdomainProxy(url, wordlist, proxy):
    ffufCommand = f"ffuf -w {wordlist} -H 'Host: FUZZ.{url}' -u {url} -x http://{proxy} -c -ac -o ffuf-scan -r --recursion --recursion-depth 2 -od scans/ffuf/subdomain/proxy -of all"
    try:
        output = subprocess.check_output(ffufCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running FFUF: {e}", style="bold red")

# Nikto
def niktoAll(url):
    console.print(f"[*] Starting Nikto Vulnerability Scan on {url}", style="bold yellow")
    niktoCommand = f"nikto -h {url} -C ALL > scans/nikto/nikto.txt"
    try:
        output = subprocess.check_output(niktoCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running Nikto: {e}", style="bold red")


if __name__ == "__main__":
    createFolders()

    parser = argparse.ArgumentParser(prog="artemis")
    subparsers = parser.add_subparsers(dest="module", help="Module to run")

    # Nmap
    tcp_parser = subparsers.add_parser("tcp", help="Run Nmap TCP scan: %(prog)s tcp TARGET")
    tcp_parser.add_argument("target", type=str, help="Target IP or hostname")

    udp_parser = subparsers.add_parser("udp", help="Run Nmap UDP scan: %(prog)s udp TARGET")
    udp_parser.add_argument("target", type=str, help="Target IP or hostname")

    # Directory Fuzzing
    ffufDir_parser = subparsers.add_parser("ffuf_dir", help="Run FFUF directory fuzzing: %(prog)s ffuf_dir URL WORDLIST")
    ffufDir_parser.add_argument("url", type=str, help="Target URL (include '/' at the end)")
    ffufDir_parser.add_argument("wordlist", type=str, help="Wordlist File")

    ffufDir_proxy_parser = subparsers.add_parser("ffuf_proxy", help="Run FFUF directory fuzzing through proxy: %(prog)s ffuf_proxy URL WORDLIST PROXY")
    ffufDir_proxy_parser.add_argument("url", type=str, help="Target URL (include '/' at the end)")
    ffufDir_proxy_parser.add_argument("wordlist", type=str, help="Wordlist File")
    ffufDir_proxy_parser.add_argument("proxy", type=str, help="Proxychains or Burpsuite Proxy (HTTP)")
    
    # Subdomain Fuzzing
    ffufSub_parser = subparsers.add_parser("ffuf_subnormal", help="Run FFUF subdomain fuzzing: %(prog)s ffuf_subnormal URL WORDLIST")
    ffufSub_parser.add_argument("url", type=str, help="Target URL")
    ffufSub_parser.add_argument("wordlist", type=str, help="Wordlist File")
    
    ffufSub_proxy_parser = subparsers.add_parser("ffuf_subproxy", help="Run FFUF directory fuzzing through proxy: %(prog)s ffuf_subproxy URL WORDLIST PROXY")
    ffufSub_proxy_parser.add_argument("url", type=str, help="Target URL")
    ffufSub_proxy_parser.add_argument("wordlist", type=str, help="Wordlist File")
    ffufSub_proxy_parser.add_argument("proxy", type=str, help="Proxychains or Burpsuite Proxy (HTTP)")
    
    # Nikto
    nikto_parser = subparsers.add_parser("nikto", help="Run Nikto Vulnerability Scan: %(prog)s nikto URL")
    nikto_parser.add_argument("url", type=str, help="Target URL")

    args = parser.parse_args()

    if args.module == "tcp":
        nmapTcp(args.target)
    elif args.module == "udp":
        nmapUdp(args.target)
        
    elif args.module == "ffuf_dir":
        ffufNormalFuzz(args.url, args.wordlist)
    elif args.module == "ffuf_proxy":
        ffufProxyFuzz(args.url, args.wordlist, args.proxy)
        
    elif args.module == "ffuf_subnormal":
        ffufSubdomainNormal(args.url, args.wordlist)
    elif args.module == "ffuf_subproxy":
        ffufSubdomainProxy(args.url, args.wordlist, args.proxy)

    elif args.module == "nikto":
        niktoAll(args.url)