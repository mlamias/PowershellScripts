$n = 4238195
$src = 'Path'
$batch = 120
$timer = [Diagnostics.Stopwatch]::StartNew()

$count = 0
Get-Content $src -ReadCount $batch -TotalCount $n | %  { 
    $count += $_.Length
    if ($count -ge $n ) {
        $_[($n - $count + $_.Length - 1)]
    }
}

$timer.Stop()
$timer.Elapsed