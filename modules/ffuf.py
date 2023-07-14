import subprocess
from rich.console import Console
console = Console()
#  Directory Fuzzing
def ffufNormalFuzz(url, wordlist):
    ffufCommand = f"ffuf -w {wordlist} -u {url}FUZZ -c -ac -o ffuf-scan -r --recursion --recursion-depth 2 -od scans/ffuf/directory/normal -of all"
    try:
        output = subprocess.check_output(ffufCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running FFUF: {e}", style="bold red")

def ffufProxyFuzz(url, wordlist, proxy):
    ffufCommand = f"ffuf -w {wordlist} -u {url}FUZZ -x http://{proxy} -c -ac -o ffuf-scan -r-od scans/ffuf/directory/proxy -of all"
    try:
        output = subprocess.check_output(ffufCommand, shell=True)
        print(output.decode('utf-8'))
    except subprocess.CalledProcessError as e:
        console.print(f"[-] An error occurred while running FFUF: {e}", style="bold red")

# Subdomain Fuzzing
def ffufSubdomainNormal(url, wordlist):
    ffufCommand = f"ffuf -w {wordlist} -H 'Host: FUZZ.{url}' -u {url} -c -ac -o ffuf-scan -r -od scans/ffuf/subdoman/normal -of all"
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
