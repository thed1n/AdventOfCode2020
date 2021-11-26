$input16 = Get-Content .\Day16\input16.txt
[System.Collections.Generic.HashSet[int32]]$validnumbers = @{}
[System.Collections.ArrayList]$nearbytickets = @()

#Must check ALL Numbers got it wrong with hashset to be smart :P
[System.Collections.ArrayList]$invalidnumbers = @()
[System.Collections.ArrayList]$validtickets = @()


$deps = $input16[0..19]
$depart = $input16[0..19] | ? { $_ -like 'departure*' }
$myticket = $input16[22] -split ','
$nearbytickets = $input16[25..$input16.count] | % {
    [array]$arr = $_ -split ','
    [pscustomobject]@{
        Tickets = $arr
    }
}

$sortedtypes = $deps | % {
    $val = ($_ -replace ' or ', ',' -replace '[a-z :]', '' -replace '-', '..' -split ',').trim()
    $f, $l = $val[0] -split '\.\.'
    $h, $n = $val[1] -split '\.\.'

    $_ | sls -Pattern '[\w ]+' | % {
        [pscustomobject]@{
            Name        = $_.matches[0].value
            LowNumbers  = $f..$l
            HighNumbers = $h..$n
            void        = $l..$h #space between valid ranges
            Low         = $f
            High        = $h
            ticketpos = 0
        }
    }
}
$deps2 = ($deps -replace ' or ', ',' -replace '[a-z :]', '' -replace '-', '..' -split ',').trim()


foreach ($d in $deps2) {
    $f, $l = $d -split '\.\.'
    $f = $f -as [int32]
    $l = $l -as [int32]
    $f..$l | % { [void]$validnumbers.add($_) }
}

foreach ($t in $nearbytickets) {
    [int32]$tempval = 0
    # $t -split ',' | %{[void]$invalidnumbers.add($_ -as [int32])}
    $t.tickets  | % {
        if ($validnumbers.Contains($_) -eq $false) {
            $tempval++
            [void]$invalidnumbers.add($_ -as [int32])
        }   
    }
    if ($tempval -eq 0) {
        [void]$validtickets.add($t.tickets)
    }
    Clear-Variable tempval | out-null

}
[void]$validtickets.add($myticket)

$sum = 0
$invalidnumbers | % {
    if ($validnumbers.Contains($_) -eq $false) {
        $sum += $_
    }
}
$sum





$maxmin = for ($j = 0; $j -lt $validtickets[0].Count; $j++) {

    [int32[]]$temp = for ($g = 0; $g -lt $validtickets.count; $g++) {
        #$validtickets[0..$validtickets.count] | % {
        $validtickets[$g][$j] -as [int32]
    }
    #}
    # $sortedtypes.void | % {
    #     $temp.Contains($_)
    # }
    foreach ($sort in $sortedtypes) {
        $tempval2 = 0

        $sort.void | % {
            if ($temp.Contains($_)) {continue}
        }
        :numbercounter for ($k = 0;$k -lt $temp.count; $k++) {
            $val = $temp[$k]      
            switch ($val) {
                { $val -ge $sort.low -and $val -lt $sort.void[0] } { $tempval2++}
                { $val -le $sort.high -and $val -gt $sort.void[-1] } { $tempval2++}
                {$val -ge $sort.void[0] -and $val -le $sort.void[-1]} {$tempval2 = 0;break numbercounter}
                #{$val -gt $sort.high -or $val -gt $sort.low} {write-host "$val either lower or higher than threshold low $($sort.low) high  $($sort.High)";break numbercounter}
                #{$val -gt $sort.high -or $val -lt $sort.low -or ($val -ge $sort.void[0] -and $val -le $sort.void[-1])} {write-host "$val either lower or higher than threshold"}
                #{$val -lt $sort.low} {$tempval2 = 0;break numbercounter}
                #{$val -gt $sort.high} {$tempval2 = 0;break numbercounter}
                Default {}
            }
            #write-host $tempval2

            if ($k -ge $temp.count-1) {
                #write-host "enter doom" -ForegroundColor red
                #if ($tempval2 -gt ($temp.count/2)) {
                    #$type[$($sort.name)]++
                    #write-host "$j,$($sort.Name),$tempval2"
                    [pscustomobject]@{
                        pos = $j
                        name = $sort.Name
                        amount = $tempval2
                    }
                #}
                $tempval2 = 0
                break
            }


        }
 
        #[hashtable]$type = @{}
        Clear-Variable tempval2
        #}
        #}
    }
}

$maxmin | Group-Object name | sort count
#if ($sort.ticketpos -lt $tempval2) {$indexpos = $sortedtypes.name.IndexOf($($sort.name)); $sortedtypes[$indexpos].ticketpos = $j}

#$first = 
$maxmin | sort name -Unique | % {
    $name = $_.name
    $pos = $_.pos
    $val = 0
    $maxmin | ? name -eq $name | % {

        if ($_.amount -gt $val) {
            $val = $_.amount
        }

     
    }
    [PSCustomObject]@{
        pos = $pos
        highest = $val
    }
    $val = 0

}

$maxmin | % {
    $name = $_.Name
    $indexpos = $sortedtypes.name.IndexOf($name)
    if ($sortedtypes[$indexpos].ticketpos -lt $_.pos) {$sortedtypes[$indexpos].ticketpos = $_.pos}


    }

    $maxmin | sort name, amount, post | select -first 1
    $sortedtypes | select name, ticketpos
<#

$maxmin | % {
    $min = $_.minimum
    $max = $_.maximum

    $sortedtypes | % {
        if ($min -ge $_.low -and $min -lt $_.void[0] -and $max -le $_.high -and $max -gt $_.void[-1]) {
            write-host "Could be $($_.Name)"
        }
    }
    
}
$min -ge $sortedtypes[1].low -and $max -le $sortedtypes[1].high
-and $min -lt $sortedtypes[0].void[0]
-and $max -gt $sortedtypes[0].void[-1]

$sortedtypes.low
$sortedtypes.high
$sortedtypes[0].void[-1]
$sortedtypes[0] | % {
    
    $validtickets[0..$validtickets.count] | % {
        $_[0]
    } | Measure-Object -Maximum -Minimum
}
#>