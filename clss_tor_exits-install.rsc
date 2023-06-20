
/system script remove clss_download_tor_exits_ipdb
/system script add name="clss_download_tor_exits_ipdb" policy=read,write,policy,test comment="download tor exits ipdb" source={
/tool fetch url="https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_tor_exits.rsc" mode=http
/ip firewall address-list remove [/ip firewall address-list find list=clss_tor_exits]
/import clss_tor_exits.rsc
}

/system scheduler remove clss_download_tor_exits_ipdb
/system scheduler add name="clss_download_tor_exits_ipdb" start-date=Jun/12/2022 start-time=02:01:00 interval="1d 00:00:00" policy=read,write,policy,test comment="run download tor exits ipdb" on-event=download_tor_exits_ipdb

/ip firewall raw add chain=prerouting src-address-list=clss_tor_exits action=drop log-prefix="_tor_exit_" comment="Drop IP from tor ip (log: _tor_exit_)+"

/system script run clss_download_tor_exits_ipdb
