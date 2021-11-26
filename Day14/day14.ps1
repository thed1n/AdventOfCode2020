$input14 = (get-content .\Day14\input14.txt).split('\n')


$input14 = @"
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"@


$input14.count

#init array with 65535 positions
$memorybank = [array]::CreateInstance([int64],[uint16]::MaxValue)


for ($i = 0; $i -lt $input14.Count; $i++) {
    
    if ($input14[$i] -like "mask = *") {
        $mask = [PSCustomObject]@{
            bor = [convert]::toint64($($input14[$i].replace('mask = ','').replace('X','0')),2)
            band = [convert]::toint64($($input14[$i].replace('mask = ','').replace('X','1')),2)
        } 
    }

    else {
        $databank = $input14[$i] | sls -AllMatches -Pattern 'mem\[(\d+)\] = (\d+)'| %{
            [PSCustomObject]@{
                Position = $($_.Matches[0].Groups[1].value)
                Value = $($_.Matches[0].Groups[2].value) -as [int64]
                Binary = [convert]::tostring($($_.Matches[0].Groups[2].value),2)
            }
        }
        $memorybank[$databank.position] = $databank.value -bor $mask.bor -band $mask.band
    }

}

[int64]$sum = 0
$memorybank | %{
    $sum += $_
}
[pscustomobject]@{
part1 = $sum
}


function get-binary ($p) {
    #Retunerar binära värdet på en position
    if ($p -eq 1) {return 1}
    if ($p -eq 2) {return 2}
    $binsum = 2
    for ($i = 3; $i -lt $p+1; $i++) {
        $binsum =$binsum+$binsum
    }
    return $binsum
}

function get-possiblecombo ([int32[]]$num) {
    #Hämtar alla möjliga kombinationer utav alla värden
    $value= [System.Collections.Generic.HashSet[int64]]::new()
    for ($i = 0; $i -lt $num.Count; $i++) {
        $val = $num[$i]
        [void]$value.add($num[$i])
        for ($x = $i+1; $x -lt $num.Count; $x++) {
            $val += $num[$x]
            [void]$value.add($val)
        }
    }
    return ,$value
}



$mask = "0101111110011010X110100010X100000XX0" -as [char[]]
$mask = "100010X100000XX0" -as [char[]]
$mask = "X1001X"
$maskchar = "X1001X" -as [char[]]
             101010
$xpos = [System.Collections.ArrayList]::new()
#hämtar alla X positioner då de är floating kan både var 1&0
for ($i = 0; $i -lt $maskchar.Count; $i++) {
    if ($maskchar[$i] -eq 'X') {[void]$xpos.add(($maskchar.count)-$i)}
}
$dec = $xpos | %{get-binary $_}
get-possiblecombo $dec

[PSCustomObject]@{
bor = [convert]::toint64($($mask.replace('mask = ','').replace('X','0')),2)
band = [convert]::toint64($($mask.replace('mask = ','').replace('X','1')),2)
}

32
33
1

42 -bor 18 #58
58+1
59-33
59-32

$mask = "0X0XX"
$maskchar = "0X0XX" -as [char[]]
26 -bor 0

26  -bxor 1
26 -bxor 8
26 -bxor 10
26 -bxor 11
26 -bxor 2
26 -bxor 3

<#
address: 000000000000000000000000000000101010  (decimal 42)
mask:    000000000000000000000000000000X1001X
result:  000000000000000000000000000000X1101X
After applying the mask, four bits are overwritten, three of which are different, and two of which are floating. Floating bits take on every possible combination of values; with two floating bits, four actual memory addresses are written:

000000000000000000000000000000011010  (decimal 26)
000000000000000000000000000000011011  (decimal 27)
000000000000000000000000000000111010  (decimal 58)
000000000000000000000000000000111011  (decimal 59)
#>


                           1011010101011000
mask = 0101111110011010X110100010X100000XX0
mem[46424] = 216719

1011010101011000
[convert]::tostring(46424,2).length



$databank = $input14 | sls -AllMatches -Pattern 'mem\[(\d+)\] = (\d+)'| %{
    #$_.matches| %{ $_.groups[1].value;$_.groups[2].value}
    [PSCustomObject]@{
        Position = $($_.Matches[0].Groups[1].value)
        Value = $($_.Matches[0].Groups[2].value)
        Binary = [convert]::tostring($($_.Matches[0].Groups[2].value),2)
    }
    #$_.Matches[0].Groups[1].value
    #$_.Matches[0].Groups[2].value
}
$hej = $input14 | sls -AllMatches -Pattern 'mem\[(\d+)\] = (\d+)|mask = ([\w\d]+)'
$hej.matches[0].Groups[3].Value

#Mask for bor
[convert]::toint32(1000000,2)
#Mask 0 = 1 , 1 = 0
#mask for band
[convert]::toint32(1111101,2)

$databank[0].Value -shl 15
$databank[0].Binary -bor '100000'
($databank[0].Value -bor 64) -band 125
$databank[1].value -bor 64 -band 125
$databank[2].value -bor 64 -band 125




[convert]::ToString(64,2) 
[convert]::ToInt32(1000000,2)

