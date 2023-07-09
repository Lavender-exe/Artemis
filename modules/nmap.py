import subprocess
from rich.console import Console
console = Console()
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