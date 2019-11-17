<#Carlos Martinez Date: 11/16/2019 GitHub @cmartinezone

DESCRIPTION: Manipulate BitLocker from WinPE Enviroment
BitLockerUtility 3.0
#>

#Set the power scheme to high performance
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

#Function To Get the Drive encrypted.
function GetDrivesEncryption {
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, ValueFromPipeLine = $false)]
        [ValidateSet("Locked", "Unlocked", "Off")]
        $Status
    )

    #Get List of Storage Devices and exclude "CD-DVD ROM".
    $ListOfDrives = Get-Volume | Where-Object { $null -ne $_.DriveLetter -and $_.DriveType -ne "CD-ROM" } 
    #Select Initial object properties. 
    $ListOfDrives = $ListOfDrives | Select-Object DriveLetter, FileSystemType, DriveType, HealthStatus, OperationalStatus, @{n = "Size / GB"; e = { [math]::truncate($_.Size / 1GB) } }
    #Add additional Properties to the output object of the Storage devices.
    $ListOfDrives | Add-Member -MemberType NoteProperty -Name Encrypted        -Value 'False'
    $ListOfDrives | Add-Member -MemberType NoteProperty -Name ProtectorStatus  -Value 'None'
    $ListOfDrives | Add-Member -MemberType NoteProperty -Name EncryptionMethod -Value 'None'
    $ListOfDrives | Add-Member -MemberType NoteProperty -Name RecoveryKeyID    -Value 'None'

    #WMI Object to query Encrypted.
    $BitLockerDrives = Get-WmiObject -Namespace "Root\cimv2\Security\MicrosoftVolumeEncryption" -Class "Win32_EncryptableVolume"
    $KeyProtectorType = 3 # Recovery password Protector type.

    #For each Drive Found in the WMI object as encrypted. 
    $BitLockerDrives | ForEach-Object {

        #Temp Variables.
        $DriveLetter      = $_.DriveLetter
        $Encrypted        = $_.IsVolumeInitializedForProtection
        $ProtectorStatus  = $_.ProtectionStatus
        $EncryptionMethod = $_.EncryptionMethod
       
        #Type of protector status. 
        switch ($ProtectorStatus) {
            ("0")   { $ProtectorStatus = "Off" }
            ("1")   { $ProtectorStatus = "On (UnLocked)" }
            ("2")   { $ProtectorStatus = "On (Locked)" }
            Default { $ProtectorStatus = "Unknown" }
        }
    
        #Type of encryption Methods. 
        switch ($EncryptionMethod) {
            ("0")   { $EncryptionMethod = "None" }
            ("1")   { $EncryptionMethod = "AES 128 WITH DIFFUSER"}
            ("2")   { $EncryptionMethod = "AES 256 WITH DIFFUSER"}
            ("3")   { $EncryptionMethod = "AES 128" }
            ("4")   { $EncryptionMethod = "AES 256" }
            ("5")   { $EncryptionMethod = "Hardware Encryption"}
            ("6")   { $EncryptionMethod = "XTS-AES 128" }
            ("7")   { $EncryptionMethod = "XTS-AES 256" }
            Default { $EncryptionMethod = "Unknown" }
        }

        #Get Recovery key (Recovery password ID).
        $RecoveryKeyID = $_.GetKeyProtectors($KeyProtectorType).volumekeyprotectorID
   
        $ListOfDrives | ForEach-Object {

            if ($DriveLetter -match $_.DriveLetter) {
                if ($_."Size / GB" -eq "0") { $_."Size / GB" = "Unknown" }
                $_.Encrypted = $Encrypted
                $_.ProtectorStatus = $ProtectorStatus
                $_.EncryptionMethod = $EncryptionMethod
                $_.RecoveryKeyID = $RecoveryKeyID
            }
        }

        #Clear Temp Variable values.
        Clear-Variable  -Name DriveLetter, Encrypted, ProtectorStatus, EncryptionMethod, RecoveryKeyID
    }
   
    switch ($Status) {
        ("UnLocked") { return $ListOfDrives | Where-Object { $_.encrypted -eq "True" -and $_.ProtectorStatus -ne "On (Locked)" } }
        ("Locked")   { return $ListOfDrives | Where-Object { $_.ProtectorStatus -eq "On (Locked)" } }
        ("Off")      { return $ListOfDrives | Where-Object { $_.encrypted -eq "False" } }
        Default      { return $ListOfDrives }
    }
}

#FUNCTION TO UNLOCK THE ENCRYPTED DRIVE
function UnLockDrive {
    
    #Get the list of Drives Found as encrypted and Locked from the main function.
    $EncryptedDrives = GetDrivesEncryption -Status Locked | Sort-Object -Property DriveLetter
    
    #If the return drives object is not null.
    if ($null -ne $EncryptedDrives) {

        if ($EncryptedDrives.Count -gt 1) { Clear-Host } #Clear console

        #Print list of drives by encrypted status.
        Write-Host "`r`nLocked Drive Volumes Detected:" -ForegroundColor Yellow
        $EncryptedDrives | Format-List -GroupBy Encrypted 
        
        #TODO: User Input request Enter the Drive Volume Letter
        Write-Host "Enter the Drive Volume Letter to Unlock:" -ForegroundColor Black -BackgroundColor Yellow -NoNewline
        $EnterDriveLetter = Read-Host  
        #Find Drive Letter in the property DriveLetter in the Object array
        $GetDrive = $EncryptedDrives | Where-Object { $_.DriveLetter -like $EnterDriveLetter }
        
        #Evaluate user input and object return 
        if ( $EnterDriveLetter.Length -eq 0 -or $EnterDriveLetter -eq "" -or $GetDrive.Count -gt 1 -or $null -eq $GetDrive ) {
        
            Write-Host "`r`nNo Drive Volume Letter Found, Please try again.`r`n"  -ForegroundColor Red
            Clear-Variable  EnterDriveLetter, GetDrive
        }
        else {
            Clear-Host #Clear console 
            Write-Host "`r`nDrive Volume selected: " -ForegroundColor Yellow
            $GetDrive #Print Drive selected
            #TODO:User Inpurt Recovery Password 
            Write-Host "Recovery Key Password IDs: "  -ForegroundColor Yellow -NoNewline
            Write-Host $GetDrive.RecoveryKeyID -ForegroundColor Green
            Write-Host "Enter the Recovery Key Password in the below format:" -ForegroundColor Yellow
            Write-Host "Recovery Key: XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX" -BackgroundColor Yellow -ForegroundColor Black
            $Key = Read-Host "Recovery Key" 
            $DriveLetter  = $GetDrive.DriveLetter + ":"

            #Evaluate Recovery key password length
            if ($key.Length -eq 55 ) {
                #Using Manage-bde 
                manage-bde -Unlock $DriveLetter -RecoveryPassword $Key | Out-String -OutVariable manageoutput | Out-Null
                #Evaluating  command output
                if ($manageoutput -match "successfully unlocked") {
                    write-Host "`r`nThe Recovery Password successfully unlocked volume: $DriveLetter `r`n" -ForegroundColor Green
                }
                else {
                    Write-Host "`n"$manageoutput -ForegroundColor Red
                    Clear-Variable  EnterDriveLetter, GetDrive, DriveLetter
                }
            }
            else {
                Write-Host "`r`nThe Recovery Key Password length is not correct, Please try again. `r`n" -ForegroundColor Red
                Clear-Variable  EnterDriveLetter, GetDrive, DriveLetter
            }
        }
    }
    else {
        Write-Host "`r`nNo Encrypted and Locked drive detected" -ForegroundColor Yellow
        Write-Host "Please make sure the Drive is connected!`r`n" -ForegroundColor Yellow
    }
}

#FUNCTION FOR TURN OF AND SUSPEND BITLOCKER ENCRYPTION
function TurnOffBitLockerAndSuspend {

    #Get the list of Drives Found as encrypted and UnLocked from the main function.
    $UnlockDrives = GetDrivesEncryption -Status Unlocked  | Sort-Object -Property DriveLetter 
    
    #If the return drives object is not null.
    if ($null -ne $UnlockDrives ) {
        if ($UnlockDrives.Count -gt 1) { Clear-Host } #Clear console
        
        #Print list of drives by Protector status
        Write-Host "`r`nUnlocked Drive Volumes Detected:" -ForegroundColor Yellow
        $UnlockDrives  | Format-List -GroupBy ProtectorStatus

        #TODO: User Input request Enter the Drive Volume Letter
        Write-Host "Enter the Drive Volume Letter:" -ForegroundColor Black -BackgroundColor Yellow -NoNewline
        $EnterDriveLetter  = Read-Host 
        #Find Drive Letter in the property DriveLetter in the Object array
        $GetDrive = $UnlockDrives | Where-Object { $_.DriveLetter -like $EnterDriveLetter }

        #Evaluate user input and object return
        if ( $EnterDriveLetter.Length -eq 0 -or $EnterDriveLetter -eq "" -or $GetDrive.Count -gt 1 -or $null -eq $GetDrive ) {
            Write-Host "`r`nNo Drive Volume Letter Found, Please try again.`r`n"  -ForegroundColor Red
            Clear-Variable  EnterDriveLetter, GetDrive
        }
        else {
            Clear-Host # Clear console
            Write-Host "`nDrive Volume selected: " -ForegroundColor Yellow
            $GetDrive #Print Drive selected
            $DriveLetter  = $GetDrive.DriveLetter + ":"
            #TODO:User Input Select one option
            Write-Host "BitLocker Options:`r`n" -ForegroundColor Yellow
            Write-Host "  -> Press 1: Turn OFF"  -ForegroundColor Yellow 
            write-Host "  -> Press 2: Suspend "  -ForegroundColor Yellow
            Write-Host "`r`nEnter one option:" -ForegroundColor Black -BackgroundColor Yellow -NoNewline
            $SelectOption = Read-Host 
              
            #Evaluate Selection if Option 1
            if ($SelectOption -eq "1" ) {
                #Using Manage-bde 
                manage-bde -off $DriveLetter | Out-String -OutVariable  Manageoutput  | Out-Null
                [string]$TestManageOutput = $Manageoutput #convert command output to string
    
                #Evaluate command ouput if description in pogress
                if ( $TestManageOutput -match "Decryption is now in progress") {
                    
                    #!Do until Drive gets full decrypted
                    do {
                    Clear-Host #Clear console
                    Write-Host "`r`nDecryption in Progress... `r`n" -ForegroundColor Yellow
                    #Get decryption progress status
                    $DecrypProgress = manage-bde -status $DriveLetter
                    
                    #Print progress output string indexes 
                    for ($i = 3; $i -lt 13; $i++) {
                        #Print two indexes with color yellow
                        if ($i -in 8, 9 ) {
                            Write-Host $DecrypProgress[$i] -ForegroundColor Yellow
                        }else{
                            Write-Host $DecrypProgress[$i]
                        }
                    }

                    #Find if error
                    if ($DecrypProgress -match "ERROR:") { $ErrorFound = $true }else { $ErrorFound = $false}
                    
                    Start-Sleep 1 # half second refresh                                              

                    } until (($DecrypProgress[8] -match "Fully Decrypted" -and  $DecrypProgress[9] -match "Percentage Encrypted: 0.0%") -or $ErrorFound -eq $true )

                    #Evaluate if not error
                    if ($ErrorFound -eq $false) {
                      Write-Host "`r`nThe Drive Volume has been Fully Decrypted :)`r`n" -ForegroundColor Green
                      pause
                    }else{
                      Write-Host "`r`nDecryption Interrupted :(`r`n" -ForegroundColor Red
                      pause
                    }
                }
                else {
                    Write-Host "`n"$Manageoutput -ForegroundColor Red
                }
            }
             #Evaluate Selection if Option 2
            elseif ($SelectOption -eq "2") {
                #Using Manage-bde 
                manage-bde -protectors -disable $DriveLetter | Out-String -OutVariable manageoutput | Out-Null
                #Evaluating  command output
                if ($manageoutput -match "Key protectors are disabled") {
                    write-Host "`r`nKey protectors are disabled for volume: $DriveLetter `r`n" -ForegroundColor Green
                }
                else {
                    Write-Host "`r`n"$manageoutput -ForegroundColor Red
                }

            }else{
                Write-Host "`r`nNo Option selected, Please try again..`r`n" -ForegroundColor Red
            }
        }
    }
    else {
        Write-Host "`r`nNo Encrypted and Unlocked drive detected" -ForegroundColor Yellow
        Write-Host "`Please UnLock the Drive first and try again!`r`n" -ForegroundColor Yellow
    }
}

Function Set-WindowSize {
    Param([int]$x=$host.ui.rawui.windowsize.width,
          [int]$y=$host.ui.rawui.windowsize.heigth)
    
        $size=New-Object System.Management.Automation.Host.Size($x,$y)
        $host.ui.rawui.WindowSize=$size   
    }

###MAIN MENU 
function WindowsTile ( $title ) { $Host.UI.RawUI.WindowTitle = $title }
function MenuOption ($Option) {  
    Write-Host  "`t $Option "
    write-Host "--------------------------------------------------------"  -ForegroundColor yellow
}

function MainMenu {
    WindowsTile ("BitLockerUtility 3.0 - By CarlosMartinez GitHub @cmartinezone")

    $MenuTitle = 'BitLockerUtility 3.0' 

    $MenuOptions = @(
        "-> Press 1: Show All Drives"
        "-> Press 2: UnLock BitLocker Drive"
        "-> Press 3: Turn OFF | Suspend BitLocker"
        "-> Press 4: Go to the CMD"
        "-> Press Q: To Quit" 
    )

    Write-Host "`n================= $MenuTitle =================`n" -ForegroundColor yellow
    $MenuOptions | ForEach-Object { MenuOption( $_ ) }
    Write-Host "`n================= $MenuTitle =================`n" -ForegroundColor yellow
}  
    
while ($UserInput -ne "q") {
    Clear-Host
    MainMenu
    Write-Host "Enter one option:" -ForegroundColor Black -BackgroundColor Yellow -NoNewline
    $UserInput = Read-Host

    switch ($UserInput) {
        1 {Write-Host "`nDrives Detected:" -ForegroundColor Yellow ; $GetDrives = GetDrivesEncryption
            if ($null -eq $GetDrives) { Write-Host "`r`nNo Encrypted Drives Detected :(`r`n" -ForegroundColor Red} else {
             $GetDrives | Sort-Object -Property DriveLetter | Format-List }; 
              Pause }
        2 { UnLockDrive ; Pause }
        3 { TurnOffBitLockerAndSuspend ; Pause }
        4 { $UserInput = "q"; Clear-Host; cmd }
        Default { }
    }
}

#Quit Execution
Get-Process -Name *cmd* | Stop-Process -Force | Out-Null
