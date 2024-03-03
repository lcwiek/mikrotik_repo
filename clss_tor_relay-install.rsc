# Create script
/system script remove clss_download_tor_relay_ipdb
/system script add name="clss_download_tor_relay_ipdb" policy=read,write,policy,test comment="download tor relay ipdb" source={
/tool fetch url="https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_tor_relay.rsc" mode=http
/ip firewall address-list remove [/ip firewall address-list find list=clss_tor_relay]
/import clss_tor_relay.rsc
}

# Create scheduler
/system scheduler remove clss_download_tor_relay_ipdb
/system scheduler add name="clss_download_tor_relay_ipdb" start-date=Jun/12/2022 start-time=02:01:00 interval="1d 00:00:00" policy=read,write,policy,test comment="run download tor relay ipdb" on-event=download_tor_relay_ipdb

# Add firewall ruls
/ip firewall raw add chain=prerouting dst-address-list=clss_tor_relay action=drop log-prefix="_tor_relay_" comment="Drop IP from tor ip (log: _tor_relay_)+"

# Manual run
/system script run clss_download_tor_relay_ipdb
