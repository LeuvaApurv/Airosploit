airosploit_valid_ip(){
#===============#
# Validation IP #
#===============#
ip="$IP"
ip_pattern='^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$'

if [[ ! $ip =~ $ip_pattern ]];then
    echo "${RED}[${WHITE}-${RED}]${RED} Invalid IP Address : ${BLUE}$ip"
    return 1
fi
for i in {1..4};do
    if [[ ${BASH_REMATCH[$i]} -gt 255 ]];then
    	echo "${RED}[${WHITE}-${RED}]${RED} Invalid octet [${BASH_REMATCH[$i]}] in : ${BLUE}$ip"
	return 1
    fi
done

if [[ ${BASH_REMATCH[1]} -eq 0 ]];then
    echo "${RED}[${WHITE}-${RED}]${RED} Zero not permitted for first octet in : ${BLUE}$ip"
    return 1
fi 
echo "${RED}[${WHITE}+${RED}]${GREEN} Valid IP Address : ${BLUE}$ip"
return 0
}

airosploit_valid_domain(){
#===================#
# Validation Domain #
#===================#
domain="$DOMAIN"
domain_pattern='(?=^.{1,254}$)(^(?>(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)'
d=$(echo $domain | grep -P $domain_pattern)

if [[ $d = $domain ]];then
    if [[ -z "$d" ]];then
    	echo "${RED}[${WHITE}-${RED}]${RED} Invalid Empty Domain Name"
    	return 1
    else
    	echo "${RED}[${WHITE}+${RED}]${GREEN} Valid Domain Name : ${BLUE}$domain"
    	return 0
   fi
else
    echo "${RED}[${WHITE}-${RED}]${RED} Invalid Doamin Name : ${BLUE}$domain"
    return 1
fi
}

