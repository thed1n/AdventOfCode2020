<#
You catch the airport shuttle and try to book a new flight to your vacation island. Due to the storm, all direct flights have been cancelled, but a route is available to get around the storm. You take it.

While you wait for your flight, you decide to check in with the Elves back at the North Pole. They're playing a memory game and are ever so excited to explain the rules!

In this game, the players take turns saying numbers. 
They begin by taking turns reading from a list of starting numbers (your puzzle input).
Then, each turn consists of considering the most recently spoken number:

If that was the first time the number has been spoken, the current player says 0.
Otherwise, the number had been spoken before; the current player announces how many turns apart the number is from when it was previously spoken.
So, after the starting numbers, each turn results in that player speaking aloud either 0 (if the last number is new) or an age (if the last number is a repeat).

For example, suppose the starting numbers are 0,3,6:

Turn 1: The 1st number spoken is a starting number, 0.
Turn 2: The 2nd number spoken is a starting number, 3.
Turn 3: The 3rd number spoken is a starting number, 6.

Turn 4: Now, consider the last number spoken, 6. Since that was the first time the number had been spoken, the 4th number spoken is 0.

Turn 5: Next, again consider the last number spoken, 0.
Since it had been spoken before, the next number to speak is the difference between the turn number when it was last spoken (the previous turn, 4)
 and the turn number of the time it was most recently spoken before then (turn 1). Thus, the 5th number spoken is 4 - 1, 3.


Turn 6: The last number spoken, 3 had also been spoken before, most recently on turns 5 and 2. So, the 6th number spoken is 5 - 2, 3.
Turn 7: Since 3 was just spoken twice in a row, and the last two turns are 1 turn apart, the 7th number spoken is 1.
Turn 8: Since 1 is new, the 8th number spoken is 0.
Turn 9: 0 was last spoken on turns 8 and 4, so the 9th number spoken is the difference between them, 4.
Turn 10: 4 is new, so the 10th number spoken is 0.
(The game ends when the Elves get sick of playing or dinner is ready, whichever comes first.)
0,3,6,0,3,3,1,0,4,0

Their question for you is: what will be the 2020th number spoken? In the example above, the 2020th number spoken will be 436.

Here are a few more examples:

Given the starting numbers 1,3,2, the 2020th number spoken is 1.
Given the starting numbers 2,1,3, the 2020th number spoken is 10.
Given the starting numbers 1,2,3, the 2020th number spoken is 27.
Given the starting numbers 2,3,1, the 2020th number spoken is 78.
Given the starting numbers 3,2,1, the 2020th number spoken is 438.
Given the starting numbers 3,1,2, the 2020th number spoken is 1836.
Given your starting numbers, what will be the 2020th number spoken?

Your puzzle input is 0,3,1,6,7,5.
#>
<#
Fungerer
$input14 = @(0,3,1,6,7,5)

$numbertable = @{}
$lastpositions = @{}

$lastnum = $input14[-1]

for ($i = 1; $i -le $input14.Count; $i++) {

        $numbertable.add($i,$input14[($i-1)])

        $pos = [PSCustomObject]@{
            first = $i
            last = $null
        }
        $lastpositions.add($input14[($i-1)],$pos)
}

# $numbertable
# $lastpositions
$i = $input14.Count+1
if ($lastpositions.ContainsKey($lastnum) -and $lastpositions.count -eq $input14.Count) {
    if ($null -eq $lastpositions[$lastnum].last) {
        $lastnum = 0
        $numbertable.add($i,$lastnum)
        if ($lastpositions.ContainsKey($lastnum) -eq $false) {
            $pos = [PSCustomObject]@{
                first = $i
                last = $null
            }
            $lastpositions[$lastnum] = $pos
        }
        else {
        $lastpositions[$lastnum].last = $i
        }
    }
}
$i++
while ($i -lt 30000001) {

    #om den redan finns beräkna och sätt nytt lastnum
    if ($lastpositions.ContainsKey($lastnum)) {

        if ($null -ne $lastpositions[$lastnum].first -and $null -ne $lastpositions[$lastnum].last) {
            $num = $lastpositions[$lastnum].last - $lastpositions[$lastnum].first


            # if ($num -eq $lastnum) {
            # $lastpositions[$lastnum].first = $lastpositions[$lastnum].last
            # $lastpositions[$lastnum].last = $i
            # }
            
            if ($lastpositions.ContainsKey($num) -eq $false) {
                $pos = [PSCustomObject]@{
                    first = $i
                    last = $null
                }
                $lastpositions[$num] = $pos
                #eftersom det är nytt sätt nuvarande plus nästa och iterera i en gång extra
                $numbertable.add($i,$num)
                $lastnum = 0
                $i++
                $numbertable.add($i,$lastnum)
                $lastpositions[$lastnum].first = $lastpositions[$lastnum].last
                $lastpositions[$lastnum].last = $i
                #$numbertable.add(($i),$num)
            }
            else {
                if ($null -ne $lastpositions[$num].last) {
                $lastpositions[$num].first = $lastpositions[$num].last
                }
                $lastpositions[$num].last = $i
                $lastnum = $num
                $numbertable.add($i,$lastnum)
            }
            
            
            #$lastpositions[$lastnum].last = $i
        }
        else {
            $lastpositions[$lastnum].last = $i
            $lastnum = 0
        }
    }

    $i++
}
$numbertable[30000000]
#>
##Efektivt som attans
function Get-AoC15 {
    param([int32[]]$input15,[double]$iterations)
    #$memo = @{} #Hashtable 1 minute 12 seconds
    [System.Collections.Generic.Dictionary[double,double]]$memo = @{} #~16 seconds
    $lastnum = 0
    $nextnumber = 0
    
    for ($i = 1; $i -le $input15.Count; $i++) {
            $memo[$input15[$i-1]] = $i
            #write-host $input14[$i-1]
    }
    $i = $input15.Count+1
    
    while ($i -lt $iterations) {
    
        if ($memo.containskey($lastnum) -eq $false) {
                $nextnumber = 0
                $memo[$lastnum] = $i
                $lastnum = $nextnumber
        }
        else {
                $nextnumber = $i - $memo[$lastnum]
                $memo[$lastnum] = $i
                $lastnum = $nextnumber
        }
        #write-host $lastnum
    
    $i++
    }
    return $lastnum
    }
    #30000000
    get-aoc15 @(1,3,2) -iterations 2020
    get-aoc15 @(2,1,3) -iterations 2020
    get-aoc15 @(1,2,3) -iterations 2020
    get-aoc15 @(2,3,1) -iterations 2020
    get-aoc15 @(3,2,1) -iterations 2020
    get-aoc15 @(3,1,2) -iterations 2020
    Get-AoC15 @(0,3,1,6,7,5) -iterations 30000000