$bagdata = get-content -Path .\Day7\part7.txt
#$bagdata = get-content -Path .\Day7\test7.txt
$pattern3 = '^(?<bag>\w+ \w+)|(?<contain>\d \w+ \w+)'
$pattern4 = '^(?<bag>\w+ \w+)|\d+ (?<contain>\w+ \w+)'


#wavy bronze
## Region Functions
function get-keyvalue ($name, $multiply, $number) {
    $multiply = $multiply -as [int32]
    $tempvalue = 0

    if ($bag.ContainsKey($v)) {
        $bag[$v].values | % {
            $tempvalue += $_ -as [int32]
        }
        $tempvalue = $multiply * $tempvalue

        return $tempvalue
    }
    else { return ($number * $multiply) }
}

function get-key ($key) {

    if ($bag.ContainsKey($key)) {
        $tempstring = $script:bag[$key] | % {
            $_
        }
     
        return $tempstring
    }   
}

function get-reversekey ($key) {

    if ($script:reversebag.containskey($key)) {
        $tempstring = $script:reversebag[$key] | % {
            $_
            $uniquebags[$_]++
        }
        return $tempstring
    }
    else {

    }
}
## End Region Functions


## Region Populate hashtable of bagdata

$bag = @{}

$reversebag = @{}
$bagamount = @{}

($bagdata | sls -Pattern $pattern3 -AllMatches).matches | % {
    if ($_.groups['bag'].value) {
        $tempbag = $_.groups['bag'].value
    }
    if ($_.groups['contain'].value) {
        $n = $_.groups['contain'].value.Substring(0, 1)
        $s = $_.groups['contain'].value.Substring(2)
        $reversebag[$s] += @($tempbag)
        $bagamount[$s] = $n
        $b = [hashtable]@{$s = $n }
        $bag[$tempbag] += @($b)
    }
}

## End Region bagdata
[hashtable]$uniquebags = @{}

$goldbags = get-reversekey -key 'shiny gold'
for ($i = 0; $i -lt $goldbags.Count; $i++) {
    #hämtar varje medlem ifrån shiny gold
    $temp = get-reversekey $goldbags[$i]
    while ($true) {
        #går igenom varje medlem ifrån ovan värde
        $temp2 = for ($j = 0; $j -lt $temp.Count; $j++) {
            if ($temp.count -eq 1) { get-reversekey $temp }
            else { get-reversekey $temp[$j] }
        }
        #om data kommer tillbaka i temp2, sätt temp till temp2 så att for loopen kör tills det inte finns någon data
        if ($temp2) {
            $temp = $temp2
        }
        else { break }
    }
}
$uniquebags.count


<#
A blue bag contains 2 violet bags.
A green bag contains 2 violet bags which each contain 2 blue bags. That makes 6 in total (4 blue ones inside the violet ones and the 2 violet ones themselves).
A yellow bag contains 2 green bags which each contains 6 bags which makes a total of 2×(6+1) = 14.
An orange bag contains 2 yellow bags which each contains 14 bags which makes a total of 2×(14+1) = 30.
A red bag contains 2 orange bags which each contains 30 bags which makes a total of 2×(30+1) = 62.
A gold bag contains 2 red bags which each contains 62 bags which makes a total of 2×(62+1) = 126.
So the calculation is 2×(1+2×(1+2×(1+2×(1+2×(1+2))))) = 126.


shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags. 
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
#>


#Nedan är för att reversera det.
function get-bagcontent ($color, $num) {
    
    if ($bag.ContainsKey($color) -eq $false) {
        #Om den inte innehåller någon väska
        return 0
    }
    $bag[$color] | ForEach-Object { #för varje väska som den innehåller
        $color = $_.keys -as [string]                       #konvertera key till string
        [int32]$numbag = $_.values | % { $_ -as [int32] }    #konvertera value till int32
        write-debug $color
        write-debug ($numbag + $numbag)
        $numbag                                                 #antal väskor
        $numbag * (get-bagcontent -color $color -num $numbag)   #antal väskor * innehållet i nästa (loopar vidare tills det inte finns fler.)
    } | Measure-Object -Sum | % Sum                             #slår ihop samtliga värden |% sum <-- visar det direkt istället för ex select-object -expandproperty sum
}

$summa = get-bagcontent -color 'shiny gold' -num 1


[PSCustomObject]@{
    'Part 1' = $uniquebags.count
    'Part 2' = $summa
}
