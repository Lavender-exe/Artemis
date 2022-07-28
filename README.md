# Artemis - Automated Recon Scanner

## About

Artemis is a project designed to trick my brain into learning scripting while convincing myself that this is saving me time and effort rather than manually typing commands

**Artemis Can:**

- Scan targets using Nmap
- Fuzz directories and DNS
- Run vulnerability scans on a target or website using Nmap scripts and Nikto

**Artemis Cannot:**

- Filter ffuf outputs (fc, fs, etc) *Yet*
- Brute force params

**To-Do List:**

- Use dig / nslookup to find domains
- Shodan option
- More options and tools
- ~~Select the ports you want to use~~
- Custom wordlists

## Requirements

- Seclists
- Nmap
- Ffuf

## Installation

```sh
git clone https://github.com/Lavender-exe/Artemis.git
chmod +x Artemis.sh
```

**Set Artemis as an alias:**

\#1 Temporary Method:

```sh
export Artemis='Artemis.sh'
```

\#2 Permanent Method (Requires sudo):

```sh
echo $0 # Find out what your terminal uses (Bash/Zsh) then edit the one you need to
sudo nano ~/.zshrc
sudo nano ~/.bashrc
```
Add this to your custom aliases:

```sh
alias Artemis='PATH_TO_FILE/Artemis.sh'
```

### Note

Artemis is under active development, bugs are to be expected.
