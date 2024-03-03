# Create script
/system script remove clss_download_blocklist_abuseipdb
/system script add name="clss_download_blocklist_abuseipdb" policy=ftp,read,write,policy,test source={
/tool fetch url="https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_wan_blacklist.rsc" 
/import clss_wan_blacklist.rsc
/file remove clss_wan_blacklist.rsc
}

# Create scheduler
/system scheduler remove clss_download_blocklist_abuseipdb
/system scheduler add name="clss_download_blocklist_abuseipdb" start-date=Jun/12/2022 start-time=01:33:00 interval="12:00:00" policy=ftp,read,write,policy,test on-event=clss_download_blocklist_abuseipdb

# Add firewall ruls
/ip firewall filter add chain=input src-address-list=clss_wan_blacklist action=drop log-prefix="_abuseipdb_" in-interface-list=WAN comment="Drop IP from abuseuipdb (log: _abuseipdb_)-" 

# Manual run
/system script run clss_download_blocklist_abuseipdb
