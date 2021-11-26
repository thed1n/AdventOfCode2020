$input10 = get-content .\Day10\part10.txt
#$input10 = Get-Content .\Day10\test10.txt
#$input10 = Get-Content .\Day10\test10_2.txt
#rated 3 higher than highest adapter (adapter+3)
#de kan leverera rätt ouput 3 under sitt värde.
#väggkontakt 0 jolts
class adapters {
[int32]$start = 0
[int32[]]$adapters = @(0)
[int32]$onejolt = 0
[int32]$threejolt = 1 # hantera datorn
[int32]$chain = 0
[int32]$computerjolt = 0
[int64]$combinations = 0
[int32]$pointer = 0
[System.Collections.ArrayList]$groups = @()

adapters ([int32[]]$input) {
    
    $this.adapters += $input|sort
    
    $this.computerjolt = ($this.adapters[-1]+3)


}
calculate () {

    $failed = $false
    for ($i = 1; $i -lt $this.adapters.Count; $i++) {
        
        switch (($this.adapters[$i] - $this.adapters[$i-1])) {
            1 { $this.onejolt++;break }
            3 { $this.threejolt++;break }
            Default {$failed = $true}
        }
        if ($failed -eq $true) {break} 
    }
    $this.chain = $i
}

Deepmind ($n) {

    if ($n -lt ($this.adapters.count)) {

    for ($i = $n; $i -lt $this.adapters.Count; $i++) {
    
        for ($x = $i; $x -lt 1000; $x++) {
            if ($x -gt ($this.adapters.count) -or $this.adapters[$x] -eq '') {break}
            
            #write-debug "$($x) $($i-1)"
            switch (($this.adapters[$x] - $this.adapters[$i-1])) {
                1 { $this.Deepmind($x+1)}
                2 { $this.deepmind($x+2)}
                3 { $this.deepmind($x+3)}
                Default {}
            }
        }
    }
    $this.combinations++
}
}

calculatepart2 () {

   
    for ($i = 1; $i -lt $this.adapters.Count; $i++) {
        $failed = $false
        
 
            switch (($this.adapters[$i] - $this.adapters[$i-1])) {
                1 {continue }
                2 {continue }
                3 { 
                    $this.groups.add(@($this.adapters[$this.pointer..($i-1)]))
                    #write-debug $($this.adapters[$this.pointer..($i-1)])
                    $this.pointer = $i
                    }
                4 {continue}
                5 {continue }
                Default {$failed = $true}
            }

        if ($failed -eq $true) {break} 
    
    }
    break
    if ($failed -eq $true) {break} 
    }

calculate3 () {

        $n = $this.adapters.Count


        $failed = $false
        for ($i = 1; $i -lt $this.adapters.Count; $i++) {
            
            switch (($this.adapters[$i] - $this.adapters[$i-1])) {
                1 { $this.onejolt++;break }
                3 { $this.threejolt++;break }
                Default {$failed = $true}
            }
            if ($failed -eq $true) {break} 
        }
        $this.chain = $i
    }
[int32[]] resultpart2 (){
    #combinations
    $low = ($this.adapters | where {$_ -lt 10}).Count
    $medium = ($this.adapters | where {$_ -ge 10 -and $_ -lt 100}).Count
    $middle = ($this.adapters | where {$_ -ge 100 -and $_ -lt 1000}).Count
    $last = ($this.adapters | where {$_ -ge 1000 -and $_ -lt 10000}).Count
    return @($low,$medium,$middle,$last)
    #10*100*1000/$this.chain
    #return [math]::Floor([math]::Sqrt(($this.onejolt*$this.twojolt*$this.threejolt)))
}

[int32] result () {
    return ($this.onejolt * $this.threejolt)
}
}

##PART 1
$jolt = [adapters]::new($input10)
$jolt.calculate()
$jolt.result()


### PART 2 (Brain Fart)
#$jolt

#PART 2 MEMOIZATION / Reversation
#big help to understand it https://www.youtube.com/watch?v=_f8N7qo_5hA&ab_channel=HeyProgrammers
$adapters = $jolt.adapters
$adapters += ($adapters[-1]+3)
Measure-Command {
NumWays -array $adapters -i 0}
function NumWays ($array,$i,$memo=@{}) {

    #om i redan besökts retunera antalet väger ifrån denna.
    if ($memo.contains($i)) {
        return $memo[$i]
    }

    #Träffas sista positionen , retunera en möjlig väg.
    if ($i -eq ($array.Length-1)) {
        return 1
    }
    [int64]$total = 0

if ($array[$i+1] -and (($array[$i+1] - $array[$i]) -le 3)) {
    $total += NumWays -array $array -i ($i+1) -memo $memo
}
if ($array[$i+2] -and (($array[$i+2] - $array[$i]) -le 3)) {
    $total += NumWays -array $array -i ($i+2) -memo $memo
}
if ($array[$i+3] -and (($array[$i+3] - $array[$i]) -le 3)) {
    $total += NumWays -array $array -i ($i+3) -memo $memo
}

$memo[$i] = $total
return $total

}


#reversation without memoization
function NumWay2 ($array,$i) {


    #Träffas sista positionen , retunera en möjlig väg.
    if ($i -eq ($array.Length-1)) {
        return 1
    }
    [int64]$total = 0

if ($array[$i+1] -and (($array[$i+1] - $array[$i]) -le 3)) {
    $total += NumWays -array $array -i ($i+1)
}
if ($array[$i+2] -and (($array[$i+2] - $array[$i]) -le 3)) {
    $total += NumWays -array $array -i ($i+2)
}
if ($array[$i+3] -and (($array[$i+3] - $array[$i]) -le 3)) {
    $total += NumWays -array $array -i ($i+3)
}


return $total

}
Measure-Command {
NumWay2 -array $adapters -i 0
}
##Learning Dynamical programming / memoization / recursiveness
function Tribonnaci_rec($n) {

    if ($n -eq 0 -or $n -eq 1 -or $n -eq 2) {return 0}

    if ($n -eq 3) {return 1}

    else {
        #write-debug $n
        write-debug $(Tribonnaci ($n -1))
        write-debug $(Tribonnaci ($n -2))
        write-debug $(Tribonnaci ($n -3))
        return ((Tribonnaci ($n -1))+(Tribonnaci ($n -2))+(Tribonnaci ($n -3)))
    }

}

$n = 10
function Tribonnaci($n) { #memo
    $memo = 0..($n+1)|%{$_}
    $memo[0],$memo[1],$memo[2],$memo[3] = 0,0,0,1
 
        foreach ($i in $(3..($n))) { 

            if ($i-1 -eq 0){ $memo[$i-1] = 0}
            if ($i-2 -eq 0){ $memo[$i-2] = 0}
            if ($i-3 -eq 0){ $memo[$i-3] = 0}
            if ($i-1 -eq 3){ $memo[$i-1] = 1}
            if ($i-2 -eq 3){ $memo[$i-2] = 1}
            if ($i-3 -eq 3){ $memo[$i-3] = 1}
            write-debug $memo[$i-1]
            write-debug $memo[$i-2]
            write-debug $memo[$i-3]
            
            $memo[$i] = $memo[$i-1] + $memo[$i-2] + $memo[$i-3]
           
          }
       # }
    return $memo[$i]
} 
function fibonacci ($n){

  $memo = 0..($n+1)|%{$_}
  $memo[0], $memo[1] = 0, 1
 
 foreach ($i in $(2..($n+1))) { 
    $memo[$i] = $memo[$i-1] + $memo[$i-2]  
   
  }
  return $memo[$n]
}

Measure-Command {Tribonnaci_rec 230}
measure-command {tribonnaci 200}
fibonacci 220
Tribonnaci ($jolt.onejolt - $jolt.threejolt)

$jolt.adapters | % {
    Tribonnaci $_
}

function reverse ($n) {
    write-debug $n
    if ($n -eq 41 -or $n -eq 90) {
        return 1
    }
    $val = 0
    
    if ($n -lt 100) { 

        $val += reverse ($n+1)
    }

    return $val
}
reverse 42
