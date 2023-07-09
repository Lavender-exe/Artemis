import subprocess
from rich.console import Console
console = Console()
# Nikto
def niktoAll(url):
    console.print(f"[*] Starting Nikto Vulnerability Scan on {url}", style="bold yellow")
    niktoCommand = f"nikto -h {url} -C ALL > scans/nikto/nikto.txt"
    try:
        output = subprocess.check_output(niktoCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running Nikto: {e}", style="bold red")
