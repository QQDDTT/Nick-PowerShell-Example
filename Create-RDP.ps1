param (
    [Parameter(Mandatory = $true)]
    [string]$Address,

    [Parameter(Mandatory = $true)] 
    [string]$Username,

    [Parameter(Mandatory = $true)]
    [string]$Password
)

# 将纯文本密码转为 SecureString
$secure = ConvertTo-SecureString "${Password}" -AsPlainText -Force

# 转为加密字符串
$encrypted = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes(
    [System.Runtime.InteropServices.Marshal]::PtrToStringUni(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    )
)) 

# 生成 RDP 文件内容
$rdpContent = @"
screen mode id:i:2
use multimon:i:0
desktopwidth:i:1920
desktopheight:i:1080
session bpp:i:32
winposstr:s:0,3,0,0,800,600
compression:i:1
keyboardhook:i:2
audiocapturemode:i:0
videoplaybackmode:i:1
connection type:i:7
networkautodetect:i:1
bandwidthautodetect:i:1
displayconnectionbar:i:1
username:s:$Username
enableworkspacereconnect:i:0
disable wallpaper:i:0
allow font smoothing:i:1
allow desktop composition:i:1
disable full window drag:i:0
disable menu anims:i:0
disable themes:i:0
disable cursor setting:i:0
bitmapcachepersistenable:i:1
full address:s:$Address
authentication level:i:2
prompt for credentials:i:0
negotiate security layer:i:1
remoteapplicationmode:i:0
alternate shell:s:
shell working directory:s:
gatewayhostname:s:
use redirection server name:i:0
rdgiskdcproxy:i:0
kdcproxyname:s:
password 51:b:$encrypted
"@

# 保存路径
$rdpFilePath = "$env:USERPROFILE\Desktop\$($Address.Replace(':', '_')).rdp"

# 写入 RDP 文件
$rdpContent | Out-File -FilePath $rdpFilePath -Encoding ASCII

