[int32[]]$values = get-content .\day1\part1.txt

for ($i = 0; $i -lt $values.Count; $i++) {
    
    for ($x = 0; $x -lt $values.Count; $x++) {
        if (($values[$i] + $values[$x]) -eq 2020) {
            $result = $values[$i] * $values[$x]
            break
        }
    }
    if ($result) {break}
}
write-host $result

### PART 2
for ($i = 0; $i -lt $values.Count; $i++) {
    
    for ($x = 0; $x -lt $values.Count; $x++) {
        
        for ($y = 0; $y -lt $values.Count; $y++) {
            if (($values[$i] + $values[$x] + $values[$y]) -eq 2020) {
                $result2 = ($values[$i] * $values[$x] * $values[$y])
                break
            }
        }
        if ($result2) {break}
    }
    if ($result2) {break}
}
write-host "Product x3 $result2"