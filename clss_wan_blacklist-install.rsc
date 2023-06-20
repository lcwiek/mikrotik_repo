
/system script remove clss_download_blocklist_abuseipdb
/system script add name="clss_download_blocklist_abuseipdb" policy=read,write,policy,test comment="download blocklist abuseipdb" source={
/tool fetch url="https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_wan_blacklist.rsc" mode=http
/ip firewall address-list remove [/ip firewall address-list find list=clss_wan_blacklist]
/import clss_wan_blacklist.rsc
}

/system scheduler remove clss_download_blocklist_abuseipdb
/system scheduler add name="clss_download_blocklist_abuseipdb" start-date=Jun/12/2022 start-time=02:01:00 interval="1d 00:00:00" policy=read,write,policy,test comment="run download blocklist abuseipdb" on-event=download_blocklist_abuseipdb

/ip firewall raw add chain=prerouting src-address-list=clss_wan_blacklist action=drop log-prefix="_abuseipdb_" comment="Drop IP from abuseuipdb (log: _abuseipdb_)-"

/system script run clss_download_blocklist_abuseipdb
