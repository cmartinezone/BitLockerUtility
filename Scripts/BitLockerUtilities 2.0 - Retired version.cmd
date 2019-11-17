@Echo OFF
Color 1E
Title .:WinPE - Windows 10 - BitLocker Utilities v2.0 - By: CarlosMartinez:.

::Date 6/17/2017 first release 1.0
::Update 7/2/207 adding support for version Windows 10 release 2.0
::Carlos Martinez: This Script was designed for doing BitLocker utilities command line easier for end user
 
::Main Menu, user can interact choosing any of the options shown
::Options 1 and 2 are mandories for Suspend, or turn off Bitlocker on the target Drive Volume

:: If the file that keep status of the encryption progress exist it goes to CleanSelections
call startnet.cmd 
if exist "hstatus.txt" goto CleanSelections
cls
:MENU
cls
Echo ========================== BITLOCKER UTILITIES V 2.0 =============================
Echo ==                                                                              ==
Echo ==                      !Complete options 1 and 2 first!                        ==
Echo ==------------------------------------------------------------------------------==
Echo ==                          1 - :: Check BitLocker Status                       == 
Echo ==                          2 - :: BitLocker Drive Unlock                       == 
Echo ==================================================================================  
Echo ==                          3 - :: Suspend BitLocker                            == 
Echo ==                          4 - :: Turn Off BitLocker                           == 
Echo ==------------------------------------------------------------------------------==
Echo ==                          5 - :: Go to Command line                           ==
Echo ==                          6 - :: Clean Selections                             ==
Echo ==------------------------------------------------------------------------------==
Echo ============================== PRESS 'Q' TO QUIT =================================
Echo.
set INPUT=
set /P INPUT=Please, Enter one of the options:
::-----------------------------------------------------------------------------------------

::Depends on user selection IF statements will route to the specifics block instruction for option selected
::Options are declared by numbers
::If there is not an option selected or the number is not an option ::Main menu will be showing over and over

If /I '%INPUT%'=='1' Goto BitLockerStatus
If /I '%INPUT%'=='2' Goto UnlockBitLocker
If /I '%INPUT%'=='3' Goto SuspendBitLocker
If /I '%INPUT%'=='4' Goto TurnOffBitLocker
If /I '%INPUT%'=='5' Goto CmdRun
If /I '%INPUT%'=='6' Goto CleanSelections
If /I '%INPUT%'=='Q' Goto Quit
Goto MENU
::---------------------------------------------------------------------------------------

::BITLOCKER STATUS: Block Of the execution instructions for Checking BitLocker status and select drive volume
::if the user has already selected the Drive volume, it will go to :ActualStatus: Block intructions. Until user select clean selections it will allow to select other Drive volume 
:BitLockerStatus
If /I '%VolumeLetter%' NEQ '' Goto ActualStatus 
cls
Echo ========================BITLOCKER DRIVE VOLUME STATUS =============================
manage-bde -status
Echo ============================= PRESS 'Q' TO QUIT ===================================
Echo.
set VolumeLetter=
set /P VolumeLetter= Please, Enter the Drive Volume letter to Unlock:
If /I '%VolumeLetter%'=='Q' Goto MENU
If /I '%VolumeLetter%' == '' Goto BitLockerstatus
Echo.
Goto MENU
::--------------------------------------------------------------------------------------------

::ACTUAL STATUS: This block of instruction will be executed if a Drive Volume letter has been selected
:ActualStatus
echo.
Echo ===============BITLOCKER DRIVE VOLUME %VolumeLetter%: STATUS =======================
manage-bde -status %VolumeLetter%:
::if the volume letter does not exist catch the error the route to exception block
If %ERRORLEVEL% NEQ 0 Goto ErrorVolume 
pause
Goto MENU
::---------------------------------------------------------------------------------------------------

::ERROR VOLUME: This Block of instruction will show a Message when the Drive Volume letter it doesn't exist
:ErrorVolume
Echo.
Echo IMPORTAT MESSAGE: !This Drive Volume does not exist or you haven't selected any Drive Volume Letter! 
Echo Please, Select a valid Drive Volume letter
set VolumeLetter=
pause
Goto BitLockerStatus
::---------------------------------------------------------------------------------------------------

::UNLOCK BITLOCKER: This block of intructions will unlock a valid Drive volume with the recovery key
:UnlockBitLocker
cls
If /I '%VolumeLetter%'=='' Goto ErrorVolume
manage-bde -status %VolumeLetter%:
If %ERRORLEVEL% NEQ 0 Goto ErrorVolume
Echo.
Echo ================BITLOCKER VOLUME %VolumeLetter%: TO UNLOCK ==========================
Echo.
Echo Please Enter the Recovery key in the fallowing Format, For the volume %VolumeLetter%:\ 
Echo. 
Echo Recovery Key:XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX
set RecoveryKey=
set /P RecoveryKey= Recovery Key:
Echo.
Echo ============================ PRESS 'Q' TO QUIT =======================================
If /I '%RecoveryKey%' == '' Goto UnlockBitLocker
If /I '%RecoveryKey%'=='Q' Goto MENU
Goto UnlockVolume
::------------------------------------------------------------------------------------------------------

::UNLOCK VOLUME: This block of intructions will be executed only if a recovery key is entered 
:UnlockVolume
Echo.
Echo BitLocker Drive Volume Unlock information
Echo.
manage-bde -unlock %VolumeLetter%: -RecoveryPassword %RecoveryKey%
If %ERRORLEVEL% NEQ 0 Goto NoneRecoveryKey
Pause
Goto MENU
::------------------------------------------------------------------------------------------------------

::NONE RECOVERY KEY: This error mensage will shows up if the recovery key it is incorrect or this drive is not valid for unlocking it
:NoneRecoveryKey
Echo.
Echo IMPORTAT MESSAGE: !You have not enter a valid Recovery Key for this Drive Volume or this Volume is not valid!
Echo. 
pause
Goto MENU
::---------------------------------------------------------------------------------------------------------

::SUSPEND BITLOCKER: This Block of intructions will suspend bitlocker temporary
:SuspendBitLocker
manage-bde -protectors -disable %VolumeLetter%:
pause
Goto MENU
::----------------------------------------------------------------------------------------------------

::TURN OFF BITLOCKER: This Block of inturctions will evaluate if an error appear for turning off bitLocker 
::it won't continue, and it will show the error, roouting to TurnOfffException block intructions
:TurnOffBitLocker
manage-bde -off %VolumeLetter%:
If %ERRORLEVEL% NEQ 0 Goto TurnOffException
Goto Decrypting 
::if there is not error routing to Decrypting block intructions
::-----------------------------------------------------------------------------------------------------

::TURN OFF EXCEPTION: if an error happens when it attempt to turn off bitlocker on the drive volume
:TurnOffException
pause 
Goto MENU
::----------------------------------------------------------------------------------------------------

::DECRYPTING: This block of intructions will keep a loop until get completed
:Decrypting
cls
Echo ============== VOLUME DRIVE %VolumeLetter%: DECRYPTION IN PROGRESS ====================
Echo.
manage-bde -status %VolumeLetter%:
Echo ------------------------------------------------------------------------------------------
echo.
Echo Decryption of Drive Volume %VolumeLetter%: in Progress...
Echo ------------------------------------------------------------------------------------------
::Create one file  with actual hard drive BitLocker Status
manage-bde -status %VolumeLetter%: > hstatus.txt
:: Delay for 6 seconds until, next update
ping -n 6 localhost >nul
::seach for the words on the file that is create everything that the loop return
find "Fully Decrypted" hstatus.txt
IF %ERRORLEVEL% == 0 Goto Completed
Goto Decrypting
::------------------------------------------------------------------------------------------------

::COMPLETE: This Block of instructions will executed when BitLocker get off
:Completed
cls
echo ======================= BITLOCKER SUCCESSFULLY TURN OFF ====================================
manage-bde -status %VolumeLetter%:
Echo ------------------------------------------------------------------------------------------
Echo.
Echo Well Done! The Drive Volume has been Successfully Decrypted!
Echo ------------------------------------------------------------------------------------------
pause 
del hstatus.txt
Goto MENU
::----------------------------------------------------------------------------------------------

:CleanSelections
set VolumeLetter=
del hstatus.txt
Goto MENU

:CmdRun
cls
start cmd.exe
Goto MENU

:Quit
cls
Echo ================================== THANK YOU :) ===========================================
Echo ------------------------------------------------------------------------------------------
Echo ============================== PRESS ANY KEY TO FINISH ====================================
pause
exit