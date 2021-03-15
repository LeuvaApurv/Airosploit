airosploit_input_ip(){
echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Your IP Adress is :" "${BLUE}"$AIROSPLOIT_IP
while true;
do
echo -en "\n${GREEN}[${WHITE}*${GREEN}]${ORANGE} Enter Target IP Address :${GREEN} "
read  IP
airosploit_valid_ip
   if [ $? -eq 0 ]; then
      break
   fi
done
}

airosploit_input_domain(){
while true;
do
echo -en "\n${GREEN}[${WHITE}*${GREEN}]${ORANGE} Enter Target Domain Name :${GREEN} "
read  DOMAIN
airosploit_valid_domain
   if [ $? -eq 0 ]; then
      break
   fi
done
}
