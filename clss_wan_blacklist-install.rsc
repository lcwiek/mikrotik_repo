# Create script
/system script remove clss_download_blocklist_abuseipdb
/system script add name="clss_download_blocklist_abuseipdb" policy=ftp,read,write,policy,test source={

# Log the start of the script
:log info "clss_download_blocklist_abuseipdb START"

# Fetch the initial package (pack 0) containing the total number of packages and store it in RAM
/tool fetch url=("https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_wan_blacklist_0.rsc") dst-path=ram
:delay 1s;

# Import the initial package to set the global variable clssWanBlacklistPacksCount
/import "ram/clss_wan_blacklist_0.rsc"
:delay 1s;

# Remove the temporary file after import
/file remove "ram/clss_wan_blacklist_0.rsc"

# Global variable that should be set during the import (total package count)
:global clssWanBlacklistPacksCount

# Loop to fetch each subsequent package (pack 1 to pack N) and save them in RAM
:for i from=1 to=$clssWanBlacklistPacksCount do={
  /tool fetch url=("https://raw.githubusercontent.com/lcwiek/mikrotik_repo/master/clss_wan_blacklist_".$i.".rsc") dst-path=ram
}

# Global variable used for cleaning countdown
:global clssWanBlacklistCleanCountdown

# If the clean countdown is greater than 1, decrement it; otherwise, reset it to 14 and clean the address list
if ($clssWanBlacklistCleanCountdown>1) do={
  :global clssWanBlacklistCleanCountdown ($clssWanBlacklistCleanCountdown-1)
} else={
  /ip firewall address-list remove [/ip firewall address-list find list=clss_wan_blacklist]
  :global clssWanBlacklistCleanCountdown 14
}

# Loop through each fetched package, import its content, and then remove the file from RAM
:for i from=1 to=$clssWanBlacklistPacksCount do={
    # Log which package is being processed
    :log info "pack $i/$clssWanBlacklistPacksCount"
    # Import the package and log any errors
    onerror e in={
      import "ram/clss_wan_blacklist_$i.rsc" verbose=yes
    } do={
      :log error "Failure - $e"
    }
    :delay 1s;

    # Remove the temporary file after import
    /file remove "ram/clss_wan_blacklist_$i.rsc"
}

# Log the end of the script
:log info "clss_download_blocklist_abuseipdb END"

}

# Create scheduler
/system scheduler remove clss_download_blocklist_abuseipdb
/system scheduler add name="clss_download_blocklist_abuseipdb" start-date=Jan/01/2022 start-time=01:33:00 interval="12:00:00" policy=ftp,read,write,policy,test on-event=clss_download_blocklist_abuseipdb

# Add firewall ruls
/ip firewall filter add chain=input src-address-list=clss_wan_blacklist action=drop log-prefix="_abuseipdb_" in-interface-list=WAN comment="Drop IP from abuseuipdb (log: _abuseipdb_)-" 

# Manual run
/system script run clss_download_blocklist_abuseipdb
