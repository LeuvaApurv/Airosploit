#!/usr/bin/evn python

import scapy.all as scapy
import optparse
import os, time


def get_arguments():
    parser = optparse.OptionParser()
    parser.add_option("-t", "--target", dest="target", help="Target IP / IP range.")
    (options, argument) = parser.parse_args()
    if not options.target:
        parser.error("[-] Please specify an target, use --help for more info.")
    return options

def scan(ip):
    arp_request = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
    arp_request_broadcast = broadcast/arp_request
    answered_list = scapy.srp(arp_request_broadcast, timeout=1, verbose=False)[0]

    clients_list = []
    for element in answered_list:
        client_dic = {"ip" : element[1].psrc, "mac" : element[1].hwsrc}
        clients_list.append(client_dic)
    return clients_list

def print_result(result_list):
    os.system('clear')
    print("\n\033[0;31;40m[-] Exit from This proocess to Press Ctrl + C\n")
    print("\n\033[0;32;40mIP Address\t\tMAC Address\n-------------------------------------------------")
    for client in result_list:
        print("\033[0;36;40m"+client["ip"] + "\t\t" + client["mac"])
try :
    options = get_arguments()
    while True:
        scan_result = scan(options.target)
        print_result(scan_result)
        time.sleep(3)
except KeyboardInterrupt:
    print("\n\n\033[0;33;40m[+] Detected CTRL + C ... \n\n\033[0;31;40m[-] Exit from This proocess.\n")
    time.sleep(3)
    os.system('exit')
except :
    print("\n\n\033[0;33;40m[+] Some Error Occurred, Please Try Again ... \n\n\033[0;31;40m[-] Exit from This proocess.\n")
    time.sleep(3)
    os.system('exit')

