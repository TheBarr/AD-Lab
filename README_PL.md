```markdown
# AD-Lab — Active Directory, Entra ID i Zabbix

Domowe laboratorium, które zbudowałem do nauki administracji systemami IT. Skonfigurowałem domenę Active Directory, usługi sieciowe, zarządzanie stacjami przez GPO, synchronizację kont z Microsoft Entra ID oraz monitoring Zabbix. Powtarzalne zadania związane z kontami użytkowników przećwiczyłem w PowerShell.

## Środowisko

- **Wirtualizacja:** Oracle VirtualBox
- **Systemy:** Windows Server 2022, Windows 11, Ubuntu Linux
- **Sieć lokalna:** `192.168.10.0/24`
- **Kontroler domeny:** `192.168.10.10`
- **Domena laboratoryjna:** `bartek.com`

![Schemat środowiska](images/Diagram.png)

### Active Directory i usługi sieciowe

- Uruchomiłem kontroler domeny AD DS.
- Utworzyłem strukturę OU dla użytkowników, kont administracyjnych, kont usługowych i stacji roboczych.
- Dodałem użytkowników i grupy zabezpieczeń.
- Skonfigurowałem DNS oraz autoryzowałem serwer DHCP z zakresem `192.168.10.100–192.168.10.200`.

Zrzuty: [struktura AD](images/ad_structure.png), [zakres DHCP](images/dhcp_scope.png), [dzierżawy](images/dhcp_leases.png), [DNS](images/dns.png).

### GPO i dostęp do zasobów

- Skonfigurowałem instalację Google Chrome z pakietu MSI przez GPO.
- Ustawiłem automatyczne mapowanie dysku sieciowego `Z:`.
- Skonfigurowałem uprawnienia udziału i NTFS do udostępnionych zasobów.

Zrzuty: [instalacja oprogramowania](images/gpo_chrome.png), [mapowanie dysku](images/mapped_drive.png).

### Ubuntu w domenie

- Dołączyłem Ubuntu do Active Directory przy użyciu `realmd` i `sssd`.
- Sprawdziłem logowanie kontem domenowym.

Zrzut: [Ubuntu w AD](images/ubuntu_ad.png).

### Synchronizacja z Microsoft Entra ID

- Zainstalowałem i skonfigurowałem Microsoft Entra Connect Sync.
- Zsynchronizowałem konta użytkowników z wybranych OU do Entra ID.
- Sprawdziłem wyniki synchronizacji lokalnie i w portalu Entra.

Zrzuty: [Entra Connect Sync](images/entra_connect_synchro.png), [konta w Entra ID](images/entra_id.png).

### Monitoring Zabbix

- Uruchomiłem monitoring kontrolera domeny i stacji roboczych.
- Skonfigurowałem instalację agenta Zabbix na Windows przez skrypt startowy GPO.
- Wykorzystałem szablony i automatyczne wykrywanie do monitorowania usług oraz sygnalizowania problemów.

Zrzut: [monitoring w Zabbix](images/zabbix_monitoring.png).

## Skrypty

| Skrypt | Działanie |
| --- | --- |
| [Create_ADusers.ps1](scripts/Create_ADusers.ps1) | Tworzy konta z CSV w wybranym OU, generuje loginy i wymusza zmianę hasła przy pierwszym logowaniu. Pomija istniejące loginy. |
| [user_raport.ps1](scripts/user_raport.ps1) | Eksportuje włączone konta z wybranego OU do CSV: imię, nazwisko, login i e-mail. |
| [inactive_users.ps1](scripts/inactive_users.ps1) | Wyłącza konta na podstawie `LastLogonDate` i ustawionego progu, domyślnie 90 dni. Ustawia opis konta z datą blokady. |
| [ZabbixInstall.bat](scripts/ZabbixInstall.bat) | Instaluje agenta Zabbix z udziału sieciowego, jeśli nie wykryje pliku wykonywalnego agenta. |

Przykłady działania: [tworzenie kont](images/powershell_create_users.png), [raport CSV](images/powershell_raport.png), [wyłączanie kont](images/powershell_inactive_users.png).

Skrypty przygotowałem na potrzeby laboratorium.
```
