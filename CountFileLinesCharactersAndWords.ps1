#Count number of lines, Words, and Characters in a file
$file2 = "c:\temp\paths.txt"
Get-Content $file2 | Measure-Object -Line -Word -Character