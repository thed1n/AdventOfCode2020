$input13 = get-content .\Day13\input13.txt
#$input11 = get-content .\Day11\test11.txt

$input13
$timestamp,$depart = $input13 -split '\n'

$offset = $depart -split ','
$depart = $depart -split ',' | where {$_ -notlike 'x'} |sort
$depart 

$timestamp / $depart[0]
function get-time ($destination,$starttime) {
$rounded = [math]::round($destination/$starttime)
return (($rounded * $starttime) - $destination)
}


function get-starttime ([int64]$starttime) {
    return (100 - $starttime)
    #return ($starttime - 0)
}

$lines = $depart | %{
    $startbus = get-starttime $_
    $bus = get-time -destination $timestamp -starttime $_ 
    [PSCustomObject]@{
        Bus = $_
        Time = [int64]$bus
        #startbus = $startbus
        timestamp = $timestamp
    }
 
} 
$result = $lines | where {$_.time -gt 0} |sort time | select -first 1 | %{ $($_.bus -as [int64])*$($_.time)}


<#
First part is fairly straightforward: starts at the number you get and then counts up.
For the second part, it's the Chinese Remainder Theorem. First step is to find the offsets for each bus,
and then the idea is that if e.g bus 7 comes 1 after time x and bus 11 comes 3 after time x,
you know the next possible time that's true would be x + 7 * 11 (it works since the bus numbers are all prime).
In my case r is the variable that is that increment.


#>



$offset = "17","x","13","19" #
#när är dessa
#B1,B2,B3,B4
#17
#   .
#      13
#         19
#17

$timediff =for ($i = 0; $i -lt $offset.Count; $i++) {
    if ($offset[$i] -ne 'x') {
        [PSCustomObject]@{
            bus = $offset[$i]
            Minute = $i
        }
    }
} 

$firstbus = $timediff[0]
$otherbus = $timediff | where {$_.minute -eq $offset[0]}


#när händer det att firstbus startar exakt 29 punkter innan otherbus
$firstbus
$otherbus
$firstbus = 7
$otherbus = 19
get-offset ($firstbus, $otherbus, $memo=@{}) {
    $offset = $firstbus
    $firstbus += 7
    $otherbus += 19



}

function get-off () {

    [System.Collections.ArrayList]$firstbus = @()
    [System.Collections.Generic.HashSet[int64]]$secondbus = @()
    $i = 0
    $busarr = @(7,7,14)
    $busarr2 = @(19,19,38)
    $bus1 = 7
    $bus2 = 19

    
    Do { 
        $busarr[0] = $busarr[2]
        $busarr[2] = $busarr[0]+$busarr[1]
        [void]$firstbus.add($busarr[2])
        $busarr2[0] = $busarr2[2]
        $busarr2[2] = $busarr2[0]+$busarr2[1]
        [void]$secondbus.add($busarr2[2]
        )

        if ($secondbus.contains(($firstbus[$i-1]+19)) -and $secondbus.contains(($firstbus[$i])))  {
            $found = $true
            return $firstbus[$i]
        }
        $i++
    } until ($found -eq $true)
}

get-off 



[PSCustomObject]@{
    part1 = $result
}
