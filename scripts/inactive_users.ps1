<#
.SYNOPSIS
Audyt bezpieczenstwa: Wyszukuje i wylacza nieaktywne konta w Active Directory.

.DESCRIPTION
Skrypt przeszukuje wskazane OU pod katem uzytkownikow, ktorzy nie logowali sie 
od okreslonej liczby dni (domyslnie 90). Znalezione "martwe" konta sa automatycznie 
wylaczane w celu zapobiegania wlamaniom, a do ich opisu dodawana jest data blokady.
#>

param (
    [Parameter(Mandatory=$false)]
    [int]$DaysInactive = 90,

    [Parameter(Mandatory=$false)]
    [string]$SearchBase = "OU=BartekCorp,DC=bartek,DC=com"
)

Import-Module ActiveDirectory

$cutoffDate = (Get-Date).AddDays(-$DaysInactive)
 
Write-Host "Szukam kont nieaktywnych od: $cutoffDate" -ForegroundColor Cyan

try {
    $inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $cutoffDate -and Enabled -eq $true} -SearchBase $SearchBase -Properties LastLogonDate
    
    if ($null -eq $inactiveUsers -or $inactiveUsers.Count -eq 0) {
        Write-Host "Brak nieaktywnych kont." -ForegroundColor Green
    } else {
        foreach ($user in $inactiveUsers) {
            Write-Warning "Wykryto nieaktywne konto: $($user.SamAccountName). Ostatnie logowanie: $($user.LastLogonDate)"
          
            Disable-ADAccount -Identity $user.SamAccountName

            $dateString = (Get-Date).ToString("yyyy-MM-dd")
            Set-ADUser -Identity $user.SamAccountName -Description "Zablokowane automatycznie - brak aktywnosci ($dateString)"
            
            Write-Host "Konto $($user.SamAccountName) zostalo bezpiecznie wylaczone." -ForegroundColor Green
        }
    }
} catch {
    Write-Error "Wystapil krytyczny blad podczas skanowania domeny: $_"
}