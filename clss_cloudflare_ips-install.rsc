# Create script
/system script remove clss_download_cloudflare_ips
/system script add name="clss_download_cloudflare_ips" policy=read,write,policy,test comment="download cloudflare ips" source={
/tool fetch url= "https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_cloudflare_ips_v4.rsc"
/ip firewall address-list remove [/ip firewall address-list find list=clss_cloudflare_ips_v4]
/import clss_cloudflare_ips_v4.rsc
/file remove clss_cloudflare_ips_v4.rsc
/tool fetch url= "https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_cloudflare_ips_v6.rsc"
/ip firewall address-list remove [/ip firewall address-list find list=clss_cloudflare_ips_v6]
/import clss_cloudflare_ips_v6.rsc
/file remove clss_cloudflare_ips_v6.rsc
}

# Create scheduler
/system scheduler remove clss_download_cloudflare_ips
/system scheduler add name="clss_download_cloudflare_ips" start-date=Jun/12/2022 start-time=02:02:00 interval="1d 00:00:00" policy=read,write,policy,test comment="run cloudflare ips" on-event=clss_download_cloudflare_ips

# Manual run
/system script run clss_download_cloudflare_ips
