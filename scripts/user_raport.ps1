<#
.SYNOPSIS
Raportowanie: Eksport aktywnych uzytkownikow do pliku CSV.

.DESCRIPTION
Skrypt przeszukuje Active Directory i generuje czytelny raport (plik .csv)
zawierajacy kluczowe informacje o aktywnych pracownikach.
#>

param (
    [Parameter(Mandatory=$false)]
    [string]$SearchBase = "OU=BartekCorp,DC=bartek,DC=com",

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "C:\Users\Bartek\Desktop\Raport_Pracownikow.csv"
)

Import-Module ActiveDirectory

Write-Host "Trwa generowanie raportu z Active Directory..." -ForegroundColor Cyan

try {
    # 1. Pobieramy tylko (aktywne) konta
    $users = Get-ADUser -Filter {Enabled -eq $true} -SearchBase $SearchBase -Properties GivenName, Surname, EmailAddress

    if ($users) {
        # 2. Formatujemy dane i wyrzucamy do pliku CSV
        $users | Select-Object GivenName, Surname, SamAccountName, EmailAddress | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8 -Delimiter ";"
        
        Write-Host "Sukces! Raport wygenerowano i zapisano na pulpicie: $OutputPath" -ForegroundColor Green
    } else {
        Write-Warning "Nie znaleziono zadnych aktywnych uzytkownikow we wskazanej lokalizacji."
    }
} catch {
    Write-Error "Wystapil blad podczas generowania raportu: $_"
}