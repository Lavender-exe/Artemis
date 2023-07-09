#!/usr/bin/env python3

import argparse
from modules.nmap import nmapTcp, nmapUdp
from modules.ffuf import ffufNormalFuzz, ffufProxyFuzz, ffufSubdomainNormal, ffufSubdomainProxy
from modules.nikto import niktoAll
from config.setup import banner, createFolders

if __name__ == "__main__":
    banner()
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
    
    ffufSub_proxy_parser = subparsers.add_parser("ffuf_subproxy", help="Run FFUF subdomain fuzzing through proxy: %(prog)s ffuf_subproxy URL WORDLIST PROXY")
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