$trees = Get-Content .\day3\part3.txt
$trees= ($trees -split '\n').trim()

#Flyttar träden eftersom mönstrerna upprepar sig så vandrar tillbaka med pekaren 
#.
#   .
#     .
#.
#   .
#      .
# .
#     .
#        .



$t = 0
[int32]$hit = 0
$slope = for ($i = 0; $i -lt $trees.Count; $i++) {
    [char[]]$row = $trees[$i]
    if ($row[$t] -eq '#') {$hit++;$row[$t]='X'}
    else {$row[$t] = 'O'}
    $t+=$r
    if ($t -ge $trees[0].Length) { $t = $t - $trees[0].Length}

    $row -as [string]

}

$hit

#$slope


## PART 2


$p2 = "1,1","3,1","5,1","7,1","1,2"

[System.Collections.ArrayList]$treehits = @()
[System.Collections.ArrayList]$slopes = @()
$p2 | %{
    [int32]$r,[int32]$d = $_ -split ","

$t = 0
[int32]$hit = 0
$slope = for ($i = 0; $i -lt $trees.Count; $i=$i+$d) {

    #VID 2 ITERATIONER
  if ($d -eq 2) {
    [char[]]$row = $trees[$i]
    [char[]]$row2 = $trees[$i+1]

    if ($row[$t] -eq '#') {$hit++;$row[$t]='X'}
    else {$row[$t] = 'O'}

}

else {[char[]]$row = $trees[$i]}

if ($d -eq 1) {
 if ($row[$t] -eq '#') {$hit++;$row[$t]='X'}
 else {$row[$t] = 'O'}

}

    $t+=$r
    if ($t -ge $trees[0].Length) { $t = $t - $trees[0].Length}

    $row -as [string]
    if ($d -eq 2) {
        $row2 -as [string]
    }

}

$hit
[void]$treehits.add($hit)
[void]$slopes.add($slope)
}

$result = 1
for ($i = 0; $i -lt $treehits.Count; $i++) {
    $result = $treehits[$i] * $result
}
$result

#$slope

#$slopes[4]
