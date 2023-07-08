# Artemis - Automated Recon Scanner

## About

Artemis is a project designed to trick my brain into learning scripting while convincing myself that this is saving me time and effort rather than manually typing commands

**Artemis Can:**

- Scan targets using Nmap
- Fuzz directories and DNS
- Run vulnerability scans on a target or website using Nmap scripts and Nikto

**To-Do List:**

- [ ] Shodan option
- [ ] More options and tools
- [x] Select the ports you want to use
- [x] Custom wordlists
- [x] Add flags instead of menu options (Menu / CLI maybe?)

**Future Projects:**
- Amass Integration for DNS Recon
- Amass to MassDNS feed 

## Requirements

- [Seclists](https://github.com/danielmiessler/SecLists)
- [Nmap](https://github.com/nmap/nmap)
- [Ffuf](https://github.com/ffuf/ffuf/)
- ~~[OWASP Amass](https://github.com/OWASP/Amass)~~
- ~~[Massdns](https://github.com/blechschmidt/massdns)~~

## Installation
The code works for Kali Linux as it was made on this OS. If it does not work for you then you will need to change the directories listed in the program to where you have your scripts.

### Bash:
```bash
git clone https://github.com/Lavender-exe/Artemis.git
chmod +x Artemis.sh
```

### Python:
```bash
pip install -r requirements.txt
python3 artemis.py --help/-h
```

**Set Artemis as an alias:**

\#1 Temporary Method:

```bash
export artemis='Artemis.sh'
```

\#2 Permanent Method (Requires sudo):

```bash
echo $0 # Find out what your terminal uses (Bash/Zsh) then edit the one you need to
sudo nano ~/.zshrc
sudo nano ~/.bashrc
```
Add this to your custom aliases:

```bash
alias artemis='sudo bash PATH_TO_FILE/Artemis.sh'
```

One Liner:

```bash
echo "alias artemis='sudo bash ~/PATH/TO/FILE/Artemis.sh'" >> ~/.bashrc
echo "alias artemis='sudo bash ~/PATH/TO/FILE/Artemis.sh'" >> ~/.zshrc

# You will have to do this once as a normal user and once as root.
```

### Note

Artemis is under active development, bugs are to be expected.
This is currently working for the latest version of Kali - It might not work for you if some of the paths are not the same (Ffuf lists)

## Contributions

*Special Thanks to:*
- [Shubakki](https://github.com/shubakki/)
