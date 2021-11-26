$input8 = Get-Content -Path .\Day8\part8.txt
#$input8 = Get-Content -path .\Day8\test8.txt
class Microcodecomputer {

    [System.Collections.ArrayList]$operations=@()
    [System.Collections.ArrayList]$instructions=@()
    [hashtable]$positions= @{}
    [int32]$acc = 0
    [int32]$pos = 0
    [int32]$change = 0 #pointer var jag bytt jmp / nop
    [string]$prevval = '' # föregående jmp/nop värdet
    [bool]$done = $false
    [int32]$runs = 0
    #[int32]$i = 0

    Microcodecomputer ($input1) {

        $input1 | %{
            [string]$instr,[int32]$num = $_ -split " "
            $this.operations.add($instr)
            $this.instructions.add($num)
        }
    }
    work (){
        $i = $this.pos

        while ($true) {
            
            if ($i -eq $this.operations.count) {$this.done = $true;break}
            #Write-Debug $i
            $this.positions[$i]++
            if ($this.positions[$i] -eq 2) {
                break
            }
            switch ($this.operations[$i]) 
            {
                'acc' {$this.accumulator($this.instructions[$i]);break}
                'jmp' {$this.jump($this.instructions[$i]);break}
                'nop' {$this.nop();break }
            }

            $i = $this.pos

        } 

    }
    reset () {
        $this.acc = 0
        $this.pos = 0
        $this.positions = @{} 
    }

    testvalue () {
            $c = $this.change
            while ($true) {
                #write-debug $c
                
                if ($this.done -eq $true) {break}      

                if ($this.operations[$c] -eq 'nop') {
                    $this.prevval = $this.operations[$c]
                    $this.operations[$c] = 'jmp'
                    $this.change = $c
                    $this.reset() #
                    $this.work() #
                    $this.runs++
                }
                elseif ($this.operations[$c] -eq 'jmp') {
                    $this.prevval = $this.operations[$c]
                    $this.operations[$c] = 'nop'
                    $this.change = $c
                    $this.reset() #
                    $this.work() #
                    $this.runs++
                }
                                
                #write-debug "previous $($this.prevval)"
                #write-debug "New val $($this.operations[$this.change])"

                #write-debug "setting $($this.operations[$this.change]) to $($this.prevval)"
                $this.operations[$this.change]=$this.prevval
                
                $c++
            }
        }
    

    [void]accumulator ([int32]$instr) {
        $this.acc += $instr
        $this.pos++
    }

    jump ([int32]$instr) {
        $this.pos += $instr
    }

    nop () {
        $this.pos++
    }

}

$computer = [Microcodecomputer]::new($input8)

$computer.work()
$part1 = $computer.acc

$computer.reset()
$computer.testvalue()
$part2 = $computer.acc


[PSCustomObject]@{
    part1 = $part1
    part2 = $part2
}