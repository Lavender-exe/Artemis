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