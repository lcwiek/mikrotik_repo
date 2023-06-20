
/system script remove clss_download_holecertdomains
/system script add name="clss_download_holecertdomains" policy=read,write,policy,test comment="download hole cert domains" source={
/tool fetch url= "https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_hole_domains.rsc" mode=http
/ip dns static remove [/ip dns static find comment="CLSS HoleCertDomains"]
/import file-name=clss_hole_domains.rsc
}

/system scheduler remove clss_download_holecertdomains
/system scheduler add name="clss_download_holecertdomains" start-date=Jun/12/2022 start-time=02:02:00 interval="1d 00:00:00" policy=read,write,policy,test comment="run download hole cert domains" on-event=clss_download_holecertdomains

/system script run clss_download_holecertdomains
