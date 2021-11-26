#added : to the end to make part 2 work.
#$inputdata2 = ((Get-Content -Path .\Day6\part6.txt -raw) -split '\n\r').trim() <-- för att få splittarna att fungera har ej använt det nu.
$inputdata = $(Get-Content -Path .\Day6\part6.txt | % {
    if ($_.length -eq 0) { ":" }
    else { $_ } };":")

$data = $inputdata -join '' -split ':'

[int32]$count = 0

ForEach ($line in $data) {

    [char[]]$l = $line
    $l1 = $l | sort -Unique
    $count += $l1.count
}

$count



#part2
[int32]$p1 = 0
[int32]$p2 = 0
[int32]$grp_num = 1
[int32]$i = 0
[int32]$count2 = 0
while ($null -eq $finish) {
    
    if ($inputdata[$i] -eq ":") {
        #write-debug "new group"

        $p2 = $i - 1
        #finds how many in the group
        if (($p2 - $p1) -eq 0) { $grp_num = 1 }
        else { $grp_num = ($p2 - $p1) + 1 }

        #write-debug $p2","$p1","$grp_num

        [char[]]$templine = $inputdata[$p1..$p2] -join ''
        $l1 = $templine | sort -Unique

        $l1 | % {
            $letter = $_
            $lettercount = ($templine | ? { $_ -eq $letter }).count
            
            #write-debug $lettercount","$grp_num

            #if lettercount matches or greater then grp add to the count
            if ($lettercount -ge $grp_num) {
                #write-debug "adding 1 to: $count2"
                $count2++
            }

        }

        $p1 = $i + 1

    }

    $i++
    if ($i -gt $inputdata.count) { break }
}
$count2

    
