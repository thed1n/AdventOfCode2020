[double[]]$input9 = Get-Content -Path .\Day9\part9.txt
#[double[]]$input9 = Get-Content -Path .\Day9\test9.txt



function get-potentialsum ($intarray) {

    [System.Collections.Generic.HashSet[double]]$temparray =@()
 
    foreach ($i in $intarray) {
        foreach ($subi in $intarray) {
            [void]$temparray.add(($i+$subi))
        }
    }
    return ,$temparray
}


function generate-contigous ($intarray,$n) {

    
    [System.Collections.Generic.HashSet[double]]$temparray =@()

    for ($i = 0; $i -lt $intarray.count; $i++) {
        [double]$value = 0
        for ($x = $i; $x -lt ($i+$n) ; $x++) {
            $value += $intarray[$x]
            #write-debug $($intarray[$x])
            
            #$x
        }
        #write-debug "reload"
        #write-debug $value
        [void]$temparray.add($value)
    }

    
    
    return ,$temparray
}


function find-topbottom ($intarray,$n,$missing) {

    
    #[System.Collections.Generic.HashSet[double]]$temparray =@()

    for ($i = 0; $i -lt $intarray.count; $i++) {
        [double]$value = 0
        for ($x = $i; $x -lt ($i+$n) ; $x++) {
            $value += $intarray[$x]
            #write-debug $x
        }
        if ($value -eq $missing) {
            $bot = $intarray[$i]
            $top = $intarray[$i]

            for ($j = $i; $j -lt $x; $j++) {
                if ($intarray[$j] -lt $bot) {$bot = $intarray[$j]}
                if ($intarray[$j] -gt $top) {$top = $intarray[$j]}
            }

            return (@($bot,$top))
            break
        }
        #[void]$temparray.add($value)
    }
}

#Preamble Length
$pl = 25

for ($i = $pl-1; $i -lt $input9.Count; $i++) {
    $preamble = get-potentialsum $input9[($i-$pl-1)..$i]
    
    if ($preamble.contains($input9[$i+1]) -eq $false) {
        $missing = $input9[$i+1]
        break
    }

}


$lessthanbug = $input9 | where {$_ -lt $missing}


for ($i = 2; $i -lt 1000; $i++) {

    $conti = generate-contigous -intarray $lessthanbug -n $i

    if ($conti.contains($missing)) {
        write-host $i
        break}

}

$sumpart2 = find-topbottom -intarray $lessthanbug -n $i -missing $missing | Measure-Object -Sum | % sum


[PSCustomObject]@{
    Part1 = $Missing
    Part2 = $sumpart2
}

