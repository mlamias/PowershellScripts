$SEL = get-content C:\the_filepath_to_search\file_name.csv
if( $SEL -imatch "string to search and match on" )
{
   Write-Host 'Contains String'
}
else
{
   Write-Host 'Does not contain String'
}
