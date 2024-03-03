# Create script
/system script remove clss_download_holecertdomains
/system script add name="clss_download_holecertdomains" policy=read,write,policy,test comment="download hole cert domains" source={
/tool fetch url= "https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_hole_domains.rsc"
#/ip dns static remove [/ip dns static find comment="CLSS HCD"]
/import file-name=clss_hole_domains.rsc
/file remove clss_hole_domains.rsc
}

# Create scheduler
/system scheduler remove clss_download_holecertdomains
/system scheduler add name="clss_download_holecertdomains" start-date=Jun/12/2022 start-time=02:01:00 interval="12:00:00" policy=ftp,read,write,policy,test on-event=clss_download_holecertdomains

# Manual run
/system script run clss_download_holecertdomains
