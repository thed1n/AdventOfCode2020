$passwords = Get-Content .\Day2\part2.txt

$valid = 0 
$passwords | ForEach-Object {
    $policy,[string]$pwd = $_ -split ":"

    $pwd = $pwd.TrimStart()

    $amount,$letter = $policy -split " "
    #$pattern = "[{0}]{{{1}}}" -f $letter,$amount-replace('-',',')
    $lower,$upper = $amount -split "-"
    $chars = ($pwd.ToCharArray() | where {$_ -eq $letter}).count

    if ($chars -ge $lower -and $chars -le $upper) {$valid++}
 
    

}

write-host $valid

##### Part2


$valid = 0 
$passwords | ForEach-Object {
    $policy,[string]$pwd = $_ -split ":"

    $pwd = $pwd.TrimStart()

    $amount,$letter = $policy -split " "
    #$pattern = "[{0}]{{{1}}}" -f $letter,$amount-replace('-',',')
    $lower,$upper = $amount -split "-"
    $chars = $pwd.ToCharArray()

    if ($chars[$lower-1] -eq $letter -and $chars[$upper-1] -ne $letter) {$valid++}
    if ($chars[$lower-1] -ne $letter -and $chars[$upper-1] -eq $letter) {$valid++}
    
}

write-host $valid


## Cool lösning hur allt asig
#$passwords|Where-Object {$L,$H,$c,$p=$_-split'\W+';$p |sls "^([^$c]*$c[^$c]*){$L,$H}$"}|measure
#regex
#'^([^n]*n[^n]*){1,10}$' #<-- Matchar allt utom n för att sedan matcha n sen allt utom n. DVS träffa n 1 - 10 gånger.