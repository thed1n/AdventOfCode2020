$input11 = get-content .\Day11\part11.txt
#$input11 = get-content .\Day11\test11.txt

#$input11


class seatingarea {

    #[System.Collections.Specialized.OrderedDictionary]$seats = @{}
    #[System.Collections.Specialized.OrderedDictionary]$tempseats = @{}
    $seats = @{}
    $tempseats = @{}
    [int64]$chairs
    [int64]$d
    [int64]$w
    [string]$lastcord
    [int64]$total
    [bool]$seatsalike = $false
    $diagpos = @{}

    build($input11) {

        $width = $input11[0].Length
        $depth = $input11.count
        $this.chairs = $width * $depth
        $this.d = $depth
        $this.w = $width
        for ($i = 0; $i -lt $depth; $i++) {
            [char[]]$chars = $input11[$i] | % { $_ -as [char[]] }
            for ($x = 0; $x -lt $width; $x++) {
            
                $this.seats.add(("$i,$x"), $chars[($x)])

            }
        }
    }

    populate() {
        #first
        for ($i = 0; $i -lt $this.d; $i++) {
            
            for ($x = 0; $x -lt $this.w; $x++) {
                
                if ($this.seats["$i,$x"] -eq "L") { $this.seats["$i,$x"] = '#' }
                if (($i -eq ($this.d - 1) -and ($x -eq ($this.w - 1)))) { $this.lastcord = "$i,$x" }
            }
        }
        $this.tempseats = $this.seats.clone()
    }
<#
    popluaterules ($depth, $width) {
        
        if ($this.seatsalike -eq $true) {
            return 
        }

        $currentcords = "$depth,$width"
        #if ($memo.Contains($currentcords)) {return}
        #$memo.add($n,"$depth,$width")

        #$depth,$width = $cors -split ","
        #$depth,$width
            
        [int64]$hits = 0


          
        for ($i = $depth - 1; $i -lt $depth + 2; $i++) {
                
            for ($x = $width - 1; $x -lt $width + 2; $x++) {
                #write-debug "$i,$x"
                if ($currentcords -ne "$i,$x") {
                    switch ($this.seats["$i,$x"]) {
                        '#' { $hits++ }
                        #'.' {  }
                        #'L' {  }
                        Default {}
                    }
                }
            }
        }

        #populate tempseats

        if ($this.seats["$currentcords"] -ne ".") {
            if ($hits -ge 4) { $this.tempseats["$currentcords"] = "L" }
            elseif ($hits -eq 0) { $this.tempseats["$currentcords"] = "#" }
            else { $this.tempseats["$currentcords"] = $this.seats["$currentcords"] }
        }
        else { $this.tempseats["$currentcords"] = '.' }
            
        #fortsätter köra rules
            
        if (($width + 1) -lt ($this.w)) {
            $this.popluaterules($depth, ($width + 1))
        }
        if (($width -eq ($this.w - 1)) -and (($depth + 1) -lt $this.d)) {
            $this.popluaterules(($depth + 1), 0)
        }
            
        #när den träffat slutet kör den igen för att köra färdigt den.
        if (($depth -eq ($this.d - 1)) -and ($width -eq ($this.d - 1))) {
            $this.copy()
            $this.total++
            $this.popluaterules(0, 0)
        }
        #end
        #if ($currentcords -eq $this.lastcord) {
        #    return
        #}
      


    }
    popluaterulesv2 ($depth, $width) {
        
        if ($this.seatsalike -eq $true) {
            return 
        }

        $currentcords = "$depth,$width"

        [int64]$hits = 0

        if ($this.seats["$($depth-1),$($width-1)"] -eq '#') { $hits++ }
        if ($this.seats["$($depth-1),$($width)"] -eq '#') { $hits++ }
        if ($this.seats["$($depth-1),$($width+1)"] -eq '#') { $hits++ }
        if ($this.seats["$($depth),$($width-1)"] -eq '#') { $hits++ }
        #if ($this.seats["$($depth),$($width)"] -eq '#') {$hits++}
        if ($this.seats["$($depth),$($width+1)"] -eq '#') { $hits++ }
        if ($this.seats["$($depth+1),$($width-1)"] -eq '#') { $hits++ }
        if ($this.seats["$($depth+1),$($width)"] -eq '#') { $hits++ }
        if ($this.seats["$($depth+1),$($width+1)"] -eq '#') { $hits++ }

        #populate tempseats

        ##write-debug $hits
        if ($this.seats["$currentcords"] -ne ".") {
            if ($hits -ge 4) { $this.tempseats["$currentcords"] = "L" }
            elseif ($hits -eq 0) { $this.tempseats["$currentcords"] = "#" }
            #else { $this.tempseats["$currentcords"] = $this.seats["$currentcords"] }
        }
        #else { $this.tempseats["$currentcords"] = '.' }
        
        #fortsätter köra rules
        
        if (($width + 1) -lt ($this.w)) {
            $this.popluaterulesv2($depth, ($width + 1))
        }
        if (($width -eq ($this.w - 1)) -and (($depth + 1) -lt $this.d)) {
            $this.popluaterulesv2(($depth + 1), 0)
        }
        
        #när den träffat slutet kör den igen för att köra färdigt den.
        if (($depth -eq ($this.d - 1)) -and ($width -eq ($this.d - 1))) {
            $this.copy()
            $this.total++
            $this.popluaterulesv2(0, 0)
        }



    }
    #>
    popluaterulesv3 () {
        
        if ($this.seatsalike -eq $true) {
            return 
        }

        foreach ($depth in 0..($this.d-1)) {
            foreach ($width in 0..($this.w-1)) {
                $currentcords = "$depth,$width"

                [int64]$hits = 0

                if ($this.seats["$($depth-1),$($width-1)"] -eq '#') { $hits++ }
                if ($this.seats["$($depth-1),$($width)"] -eq '#') { $hits++ }
                if ($this.seats["$($depth-1),$($width+1)"] -eq '#') { $hits++ }
                if ($this.seats["$($depth),$($width-1)"] -eq '#') { $hits++ }
                #if ($this.seats["$($depth),$($width)"] -eq '#') {$hits++}
                if ($this.seats["$($depth),$($width+1)"] -eq '#') { $hits++ }
                if ($this.seats["$($depth+1),$($width-1)"] -eq '#') { $hits++ }
                if ($this.seats["$($depth+1),$($width)"] -eq '#') { $hits++ }
                if ($this.seats["$($depth+1),$($width+1)"] -eq '#') { $hits++ }

                #populate tempseats

                ##write-debug $hits
                if ($this.seats["$currentcords"] -ne ".") {
                    if ($hits -ge 4) { $this.tempseats["$currentcords"] = "L" }
                    elseif ($hits -eq 0) { $this.tempseats["$currentcords"] = "#" }
                    #else { $this.tempseats["$currentcords"] = $this.seats["$currentcords"] }
                }
                #else { $this.tempseats["$currentcords"] = '.' }
        


                #när den träffat slutet kör den igen för att köra färdigt den.
                if (($depth -eq ($this.d - 1)) -and ($width -eq ($this.d - 1))) {
                    $this.copy()
                    $this.total++
                    $this.popluaterulesv3()
                }
            }
        }



    }
    part3 () {
        
        if ($this.seatsalike -eq $true) {
            return 
        }   
        $this.diagpos.GetEnumerator() |foreach-object {
            $hits = 0
            $currentcords = $_.key
            #kör foreach på underarrayen
            $this.diagpos[$currentcords] | foreach-object {
                $neigh = $_

                    switch ($this.seats[$neigh]) {
                        '#' { $hits++;break}
                        '.' { break}
                        'L' { break  }
                        Default {break}
                    }    
            }
            if ($this.seats["$currentcords"] -ne ".") {
                if ($hits -ge 5) { $this.tempseats["$currentcords"] = "L" }
                elseif ($hits -eq 0) { $this.tempseats["$currentcords"] = "#" }
            }
            }
          #när den träffat slutet kör den igen för att köra färdigt den.
            $this.copy()
            $this.total++
            $this.part3()
        }

    finddiagonalneigh () {

        $x_topoutofbound = -1
        $y_topoutofbound = -1
        $this.seats.GetEnumerator() | foreach-object {
    
            [System.Collections.ArrayList]$tempneigh = @()
        
            #depth,#width 5,5
            [int64]$de,[int64]$wi = $_.name -split ","
            if ($this.seats["$de,$wi"] -notlike '.') {
                #write-debug "Starting with $de,$wi"
            


            $done = $false
            $y = ($de-1)
            $x = ($wi-1)
           :diagtopleft while ($done -eq $false) {
                #diagonal top left
                #write-debug "topleft $y,$x"
              
                
                        switch ($this.seats["$($y),$($x)"]) {
                        'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                        '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                        }
                if ($y -gt $y_topoutofbound) {$y--}
                else {break :diagtopleft}
                if ($x -gt $x_topoutofbound) {$x--}
                else {break :diagtopleft}
                

        }
            $done = $false
            $y = ($de-1)
            $x = $wi
            :top while ($done -eq $false) {
                #top
                #write-debug "top $y,$x"
            
                        switch ($this.seats["$($y),$($x)"]) {
                        'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                        '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                        }
                    
        
                    if ($y -ne $y_topoutofbound) {$y--}
                    else {break :top}
            }
        
            $done = $false
            $y = ($de-1)
            $x = ($wi+1)
            :diagtopright while ($done -eq $false) {
                #diagonal top right

                        #write-debug "topright $y,$x"
                        switch ($this.seats["$($y),$($x)"]) {
                        'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                        '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                        }
                        if ($y -ne $y_topoutofbound) {$y--}
                        else {break :diagtopright}
                        if ($x -lt $this.w) {$x++}
                        else {break :diagtopright}
        

        }

                $done = $false
                $y = $de
                $x = ($wi+1)
            :right while ($done -eq $false) {
                #right
  
                #write-debug "right $y,$x"
                        switch ($this.seats["$($y),$($x)"]) {
                        'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                        '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                        }
                        if ($x -lt $this.w) {$x++}
                        else {break :right}
            
            }
            $done = $false
                $y = ($de+1)
                $x = ($wi+1)
            :diaglowright while ($done -eq $false) {
                #diagonal low right
                #write-debug "lowright $y,$x"
         
                                  
                        switch ($this.seats["$($y),$($x)"]) {
                        'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                        '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                        }
                        if ($y -lt $this.d) {$y++}
                        else {break :diaglowright}
                        if ($x -lt $this.w) {$x++}
                        else {break :diaglowright}

        }

                $done = $false
                $y = ($de+1)
                $x = $wi
        :bot while ($done -eq $false) {
            #top
            #write-debug "top $y,$x"
           
                    switch ($this.seats["$($y),$($x)"]) {
                    'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                    '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                    }
                    if ($y -lt $this.d) {$y++}
                    else {break :bot}
          
        }
        $done = $false
        
        $y = ($de+1)
        $x = ($wi-1)
        :diaglowleft while ($done -eq $false) {
            #diagonal low left

                #write-debug "diaglowleft $y,$x"
                    switch ($this.seats["$($y),$($x)"]) {
                    'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                    '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                    }
                    if ($y -lt $this.d) {$y++}
                        else {break :diaglowleft}
                        if ($x -ge $x_topoutofbound) {$x--}
                        else {break :diaglowleft}
   
        }
        $done = $false
        $y = $de
        $x = ($wi-1)
        :left while ($done -eq $false) {
            #left
     
            #write-debug "left $y,$x"   
                    switch ($this.seats["$($y),$($x)"]) {
                    'L' {[void]$tempneigh.add("$y,$x");$done = $true}
                    '#' {[void]$tempneigh.add("$y,$x");$done = $true}
                    }
                    if ($x -ne $x_topoutofbound) {$x--}
                    else {break :left}
           
        }
        $this.diagpos.add("$de,$wi",$tempneigh)
        }
    }

    }
    draw () {
        for ($i = 0; $i -lt $this.d; $i++) {
            
            for ($x = 0; $x -lt $this.w; $x++) {
            
                write-host "$($this.seats["$i,$x"])" -NoNewline

            }
            write-host ""
        }
    }
    drawtemp () {
        for ($i = 0; $i -lt $this.d; $i++) {
            
            for ($x = 0; $x -lt $this.w; $x++) {
            
                write-host "$($this.tempseats["$i,$x"])" -NoNewline

            }
            write-host ""
        }
    }
    copy () {
        #if not this then it will be linked

        #check if its alike
        $alike = 0
        $this.tempseats.GetEnumerator() | % {
            $key = $_.name
            $value = $_.Value
            if ($this.seats[$key] -eq $value ) {
                $alike++
            }
        }
        ##write-debug $alike
        if ($alike -eq $this.chairs) {
            $this.seatsalike = $true
        }
        #clone hashtable
        $this.seats = $this.tempseats.clone()

        <#
        $this.tempseats.GetEnumerator() | %{
                $key = $_.name
                $value = $_.Value
                $this.seats[$key] = $value
        }
        #>
    
    }

    [string] result () {
        $occupied = 0
        $this.seats.GetEnumerator() | % {
            if ($_.Value -eq '#') {
                $occupied++
            }
        }
        return $occupied
    }
}



$seating = [seatingarea]::new()
$seating.build($input11)
$seating.populate()

$seating.popluaterulesv3()
$seating.result() #part1

$seating.finddiagonalneigh() #part2
$seating.part3()
$seating.result()
$seating.draw()


#$seating.diagpos["8,5"]
#$seating.diagpos["7,4"]
#$seating.seatsalike = $false
