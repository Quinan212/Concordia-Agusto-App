# Ejecutar este script desde PowerShell con permisos de Administrador.
# Esto habilita el hipervisor de Windows necesario para el emulador Android x86_64.

Write-Output "Habilitando Windows Hypervisor Platform y Hyper-V..."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
if ($LASTEXITCODE -ne 0) { Write-Error "Error habilitando VirtualMachinePlatform"; exit $LASTEXITCODE }

dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V-All /all /norestart
if ($LASTEXITCODE -ne 0) { Write-Error "Error habilitando Hyper-V"; exit $LASTEXITCODE }

Write-Output "Configurando hypervisorlaunchtype a auto..."
bcdedit /set hypervisorlaunchtype auto
if ($LASTEXITCODE -ne 0) { Write-Error "Error configurando bcdedit"; exit $LASTEXITCODE }

Write-Output "Listo. Reinicie el equipo para aplicar los cambios."
