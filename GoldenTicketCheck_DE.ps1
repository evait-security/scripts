PARAM ($EndTime = 10) 
#************************************************ 
# GoldenTicketCheck.ps1 
# Version 1.1 
# Date: 01-29-2015 
# Updated: 3-23-2015 
# Author: Tim Springston [MSFT] 
# Description: This script queries the local computer's Kerberos ticket caches 
#  for TGTs and service tickets which have do not match the default domain duration for renewal.  
#  This script is not certain to point out golden tickets if present, it simply  
#  points out tickets to be examined. Details of the ticket are presented at the PS 
#  prompt. 
#************************************************ 
cls 
$Date = Get-Date 
$KerbCheckOutput = $env:systemroot + "\temp\KerberosGoldenTicketChecks.txt" 
function GetKerbSessionInfo 
    { 
    $OS = gwmi win32_operatingsystem 
    $sessions = New-Object PSObject 
    if ($OS.Buildnumber -ge 9200) 
        { 
        $KlistSessions = klist sessions 
        $Counter = 0 
        foreach ($item in $KlistSessions) 
            { 
            if ($item -match "^\[.*\]") 
                { 
                $LogonId = $item.split(' ')[3] 
                $LogonId = $LogonId.Replace('0:','') 
                if ($LogonId -match '[0-9]') 
                    { 
                    $Identity = $item.split(' ')[4] 
                    $Token5 = $item.Split(' ')[5] 
                    $AuthnMethod = $Token5.Split(':')[0] 
                    $LogonType = $Token5.Split(':')[1] 
                    $Session = New-Object PSObject 
                    Add-Member -InputObject $Session -MemberType NoteProperty -Name "SessionID" -Value $LogonId 
                    Add-Member -InputObject $Session -MemberType NoteProperty -Name "Identity" -Value $Identity 
                    Add-Member -InputObject $Session -MemberType NoteProperty -Name "Authentication Method" -Value $AuthnMethod             
                    Add-Member -InputObject $Session -MemberType NoteProperty -Name "Logon Type" -Value $LogonType 
                    Add-Member -InputObject $sessions -MemberType NoteProperty -Name $LogonId -Value $Session 
                    $Session = $null 
                    } 
                } 
            } 
        } 
    else 
        { 
        $WMILogonSessions = gwmi win32_LogonSession 
        foreach ($WMILogonSession in $WMILogonSessions) 
            { 
            $LUID = [Convert]::ToString($WMILogonSession.LogonID, 16) 
            $LUID = '0x' + $LUID 
            $Session = New-Object PSObject 
            Add-Member -InputObject $Session -MemberType NoteProperty -Name "SessionID" -Value $LUID 
            Add-Member -InputObject $Session -MemberType NoteProperty -Name "Identity" -Value "Not available" 
            Add-Member -InputObject $Session -MemberType NoteProperty -Name "Authentication Method" -Value $WMILogonSession.AuthenticationPackage         
            Add-Member -InputObject $Session -MemberType NoteProperty -Name "Logon Type" -Value $WMILogonSession.LogonType 
                 
            Add-Member -InputObject $sessions -MemberType NoteProperty -Name $LUID -Value $Session 
            $Session = $null 
            } 
        } 
    return $sessions 
    } 
 
function GetKerbSessionList 
    { 
    $OS = gwmi win32_operatingsystem 
    $sessions = @() 
    if ($OS.Buildnumber -ge 9200) 
        { 
        $KlistSessions = klist sessions 
        $Counter = 0 
 
        foreach ($item in $KlistSessions) 
            { 
            if ($item -match "^\[.*\]") 
                { 
                $LogonId = $item.split(' ')[3] 
                $LogonId = $LogonId.Replace('0:','') 
                if ($LogonId -match '[0-9]') 
                    { 
                    $sessions += $LogonId 
                    $Session = $null 
                    } 
                } 
             
            } 
        } 
    else 
        { 
        $WMILogonSessions = gwmi win32_LogonSession 
        foreach ($WMILogonSession in $WMILogonSessions) 
            { 
            $LUID = [Convert]::ToString($WMILogonSession.LogonID, 16) 
            $LUID = '0x' + $LUID 
            $Session = New-Object PSObject 
            $sessions += $LUID   
            } 
        } 
    return $sessions 
    } 
 
function CheckSessionForTGTGoldenTicket 
    { param ($sessionID, $TGTEndTime) 
    $TGTsArray =  klist.exe tgt -li $sessionID 
    if ($TGTsArray -match "LsaCallAuthenticationPackage") 
        {return $false} 
    foreach ($line in $TGTsArray) 
            { 
            if ($line -match "StartTime") 
                { 
                $StartTime = $line 
                $StartTime = $StartTime.Replace('StartTime          : ','') 
                $StartTime = $StartTime.Replace(' (lokal)','') 
                [datetime]$DTStartTime = $StartTime 
                } 
            if ($line -match "EndTime") 
                { 
                $EndTime = $line 
                $EndTime = $EndTime.Replace('EndTime            : ','')  
                $EndTime = $EndTime.Replace(' (lokal)','') 
                [datetime]$DTEndTime = $EndTime 
                } 
            } 
    #Compare Dates vs the domain specified expiry 
    $TGTExpiry = $DTEndTime - $DTStartTime 
    $DomainTGTExpiry = New-TimeSpan -Hours $TGTEndTime 
    if ($TGTExpiry -gt $DomainTGTExpiry) 
        { 
        $TGT = New-Object PSObject 
        Add-Member -InputObject $TGT -MemberType NoteProperty -Name "TGT Session (LogonID)" -Value $TGTsArray[1].Replace('Aktuelle Anmelde-ID ist 0:','') 
        Add-Member -InputObject $TGT -MemberType NoteProperty -Name "Service Name" -Value $TGTsArray[5].Replace('ServiceName        : ','') 
        Add-Member -InputObject $TGT -MemberType NoteProperty -Name "ClientName (user)" -Value $TGTsArray[7].Replace('ClientName         : ','') 
        add-Member -InputObject $TGT -MemberType NoteProperty -Name "DomainName" -Value $TGTsArray[8].Replace('DomainName         : ','') 
        add-Member -InputObject $TGT -MemberType NoteProperty -Name "SitzungsschlÅssel" -Value $TGTsArray[12].Replace('SitzungsschlÅssel        : ','') 
        Add-Member -InputObject $TGT -MemberType NoteProperty -Name "StartTime" -Value $TGTsArray[14].Replace('StartTime          : ','') 
        Add-Member -InputObject $TGT -MemberType NoteProperty -Name "EndTime" -Value $TGTsArray[15].Replace('EndTime            : ','') 
        Add-Member -InputObject $TGT -MemberType NoteProperty -Name "Erneuerungszeit" -Value $TGTsArray[16].Replace('Erneuerungszeit: ','') 
        return $TGT 
        } 
        else {return $false} 
    } 
function CheckSessionForTGSGoldenTicket 
    { param ($sessionID, $TGSEndTime) 
    $TicketsArray =  klist.exe tickets -li $sessionID 
    $DomainTGTExpiry = New-TimeSpan -Hours $TGSEndTime 
    $LogonID = $TicketsArray[1].Replace("Aktuelle Anmelde-ID ist 0:","") 
    $LineCounter = 0 
    $Found = $false 
    $SessionTickets  = @() 
    $OS = gwmi win32_operatingsystem 
    if ($TicketsArray -match "LsaCallAuthenticationPackage") 
        {return $false} 
    foreach ($line in $TicketsArray) 
            { 
            if ($Line -match "#") 
                { 
                $StartTime = $TicketsArray[$LineCounter+4] 
                $StartTime = $StartTime.Replace('	Startzeit: ','') 
                $StartTime = $StartTime.Replace(' (lokal)','') 
                [datetime]$DTStartTime = $StartTime 
                $EndTime = $TicketsArray[$LineCounter+5] 
                $EndTime = $EndTime.Replace('	Endzeit:   ','')  
                $EndTime = $EndTime.Replace(' (lokal)','') 
                [datetime]$DTEndTime = $EndTime 
                $Ticket = New-Object PSObject 
                $ClientLine = $Line.Split('>')[1] 
                $ClientLine = $ClientLine.Replace('ClientName         : ','') 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "Session (LogonID)" -Value $LogonID 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "Client" -Value $ClientLine 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "Server (Service)" -Value $TicketsArray[$LineCounter+1].Replace('	Server: ','') 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "Encryption Type" -Value $TicketsArray[$LineCounter+2].Replace('	KerbTicket (VerschlÅsselungstyp): ','') 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "Ticket Flags" -Value $TicketsArray[$LineCounter+3].Replace('	Ticketkennzeichen ','') 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "Startzeit" -Value $TicketsArray[$LineCounter+4].Replace('	Startzeit: ','') 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "Endzeit" -Value $TicketsArray[$LineCounter+5].Replace('	Endzeit:   ','') 
                Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "RenewUntil" -Value $TicketsArray[$LineCounter+6].Replace('	Erneuerungszeit: ','') 
                if ($OS.Buildnumber -ge 9200) 
                    {Add-Member -InputObject $Ticket -MemberType NoteProperty -Name "KDC Called" -Value $TicketsArray[$LineCounter+9].Replace('	KDC aufgerufen: ','')} 
                     
                #Compare Dates vs the domaain specified expiry 
                $TicketExpiry = $DTEndTime - $DTStartTime 
                if ($TicketExpiry -gt $DomainTGTExpiry) 
                    { 
                    $SessionTickets += $Ticket 
                    #Write-host -Object $Ticket 
                    $Found = $true 
                    } 
                } 
        $LineCounter++ 
        } 
    if ($Found -ne $false) 
        {return $SessionTickets} 
        else 
            {return $false} 
    } 
         
$sessionINFO = GetKerbSessionInfo 
$SessionList = GetKerbSessionList 
$FoundFlag = $False 
 
Get-Date | Out-File $KerbCheckOutput  -encoding UTF8  
"Review of local Kerberos ticket caches for ticket granting tickets (TGTs) or service tickets which have durations which differ from the domain specified ticket duration and hence may be maliciously created." | Out-File $KerbCheckOutput -encoding UTF8 -Append 
foreach ($Session in $SessionList) 
    { 
    $SessionReturn = CheckSessionForTGTGoldenTicket $Session $EndTime 
    if ($SessionReturn -ne $false) 
        { 
        Write-Host "We have one or more potential Golden Ticket TGTs here folks." -BackgroundColor Red 
        Write-Host "Listing session information and ticket details..." -BackgroundColor Red  
        "We have one or more potential Golden Ticket TGTs here folks." | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        "Listing session information and ticket details..." | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        $CurrentSession = $sessionINFO.($Session)  
        $CurrentSession | FL  | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        $SessionReturn  | FL * | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        $CurrentSession | FL  
        $SessionReturn | FL * 
        $FoundFlag = $true 
        } 
     
    $SessionReturn = CheckSessionForTGSGoldenTicket $Session $EndTime 
    if ($SessionReturn -ne $false) 
        { 
        Write-Host "We have one or more potential Golden Ticket service tickets here folks." -BackgroundColor Red 
        Write-Host "Listing session information and ticket details..." -BackgroundColor Red  
        "We have one or more potential Golden Ticket service tickets here folks."  | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        "Listing session information and ticket details..." | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        $sessionINFO.($Session) | FL | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        $sessionINFO.($Session) | FL  
        "Note: LogonID may not match Session info if the cache is for Kerberos delegation or services for user."   | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        "Note: LogonID may not match Session info if the cache is for Kerberos delegation or services for user."  | FL  
        $SessionReturn | FL * | Out-File $KerbCheckOutput -encoding UTF8 -Append 
        $SessionReturn | FL * 
        $FoundFlag = $true 
        } 
 
    } 
 
 
if ($FoundFlag -eq $false) 
    { 
    Write-Host "No potential Golden Ticket TGTs or service tickets found in local Kerberos session caches." -BackgroundColor Green  
    "No potential Golden Ticket TGTs or service tickets found in local Kerberos session caches." | Out-File $KerbCheckOutput -encoding UTF8 -Append 
    } 
