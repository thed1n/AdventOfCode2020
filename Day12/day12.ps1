$input12 = get-content .\Day12\input12.txt
#$input11 = get-content .\Day11\test11.txt

<#
$input12 = @"
F10
N3
F7
R90
F11
"@
$input12 = $input12 -split '\n'
#>
class ship {
    $bearing = 'E'
    [int32]$ew = 0
    [int32]$ns = 0
    [int32]$sew = 0 #ship ew #part2
    [int32]$sns = 0 #ship ns #part2
    [int32]$wew = 10 #waypoint eastwest
    [int32]$wns = 1 #waypoint north south
    [int32]$bigboat = 0
   
    
    [uint32]manhattan () {
        return ([math]::abs($this.ew) + [math]::abs($this.ns))
    }
    [uint32]part2 () {
        return ([math]::abs($this.sew) + [math]::abs($this.sns))
    }
    move([int32]$distance) {
        $this.sns += ($this.wns * $distance)
        $this.sew += ($this.wew * $distance)
    }
    rotatewaypoint($direction, $angle) {

        switch ($direction) {
            'R' { 
                switch ($angle) {
                    90 {
                        $r1 = $this.wew
                        $r2 = $this.wns
                        if ($r1 -gt 0) {
                            $this.wns = -[math]::abs($r1)
                        }
                        else {
                            $this.wns = [math]::abs($r1)
                        }
                        if ($r2 -gt 0) {
                            $this.wew = [math]::abs($r2)
                        }
                        else {
                            $this.wew = -[math]::abs($r2)
                        }
                    }
                    180 {
                        $r1 = $this.wew
                        $r2 = $this.wns
                        if ($r1 -gt 0) {
                            $this.wew = -[math]::abs($r1)
                        }
                        else { $this.wew = [math]::abs($r1) }

                        if ($r2 -gt 0) {
                            $this.wns = -[math]::abs($r2)
                        }
                        else { $this.wns = [math]::abs($r2) }
                    }
                    270 {

                        $r1 = $this.wew
                        $r2 = $this.wns

                        if ($r1 -gt 0) { #om east
                            $this.wns = [math]::abs($r1) #blir norr
                        }
                        else {
                            $this.wns = -[math]::abs($r1) #är west blir south
                        }

                        if ($r2 -gt 0) { #om norr
                            $this.wew = -[math]::abs($r2) #blir west
                        }
                        else {
                            $this.wew = [math]::abs($r2) #om norr blir east
                        }
                    }  
                }
            }
            'L' {  
                switch ($angle) {
                    90 {
                        $r1 = $this.wew
                        $r2 = $this.wns
                        if ($r1 -gt 0) {
                            $this.wns = [math]::abs($r1)
                        }
                        else {
                            $this.wns = -[math]::abs($r1)
                        }
                        if ($r2 -gt 0) {
                            $this.wew = -[math]::abs($r2)
                        }
                        else {
                            $this.wew = [math]::abs($r2)
                        }
                        
                    }
                    180 {
                        $r1 = $this.wew
                        $r2 = $this.wns
                        if ($r1 -lt 0) { #om west
                            $this.wew = [math]::abs($r1) #blir east
                        }
                        else { $this.wew = -[math]::abs($r1) } #annars blir west
                        if ($r2 -lt 0) { #om south
                            $this.wns = [math]::abs($r2) #blir north
                        }
                        else { $this.wns = -[math]::abs($r2) } #om north blir south
                    }
                    270 {

                        $r1 = $this.wew
                        $r2 = $this.wns

                        if ($r1 -gt 0) { #om east
                            $this.wns = -[math]::abs($r1) #blir söder
                        }
                        else {
                            $this.wns = [math]::abs($r1) #är west blir norr
                        }

                        if ($r2 -gt 0) { #om norr
                            $this.wew = [math]::abs($r2) #blir east
                        }
                        else {
                            $this.wew = -[math]::abs($r2) #om norr blir west
                        }
        
                    }  
                }
            }
        }
    }

}

$bigboat = [ship]::new()

foreach ($in in $input12) {

    $where2 = $in.substring(0, 1)
    [int32]$distance = $in.substring(1)
    #write-host "$where2 , $distance"

    switch ($where2) {
        'N' { $bigboat.ns += $distance; $bigboat.wns += $distance } #means to move bigboat.north by the given value.
        'S' { $bigboat.ns -= $distance; $bigboat.wns -= $distance } #means to move south by the given value.
        'E' { $bigboat.ew += $distance; $bigboat.wew += $distance } #means to move east by the given value.
        'W' { $bigboat.ew -= $distance; $bigboat.wew -= $distance } #means to move west by the given value.
        'L' {   
            $bigboat.rotatewaypoint($where2, $distance)
            switch ($distance) {
                90 {
                    switch ($bigboat.bearing) {
                        'E' { $bigboat.bearing = 'N' }
                        'W' { $bigboat.bearing = 'S' }
                        'N' { $bigboat.bearing = 'W' }
                        'S' { $bigboat.bearing = 'E' }
                    }
                }
                180 {
                    switch ($bigboat.bearing) {
                        'E' { $bigboat.bearing = 'W' }
                        'W' { $bigboat.bearing = 'E' }
                        'N' { $bigboat.bearing = 'S' }
                        'S' { $bigboat.bearing = 'N' }
                    }
                }
                270 {

                    switch ($bigboat.bearing) {
                        'E' { $bigboat.bearing = 'S' }
                        'W' { $bigboat.bearing = 'N' }
                        'N' { $bigboat.bearing = 'E' }
                        'S' { $bigboat.bearing = 'W' }
                    }
                }  
            }
        } #means to turn left the given number of degrees.
        'R' {
            #means to turn right the given number of degrees.
            $bigboat.rotatewaypoint($where2, $distance)
            switch ($distance) {
                90 {
                    switch ($bigboat.bearing) {
                        'E' { $bigboat.bearing = 'S' }
                        'W' { $bigboat.bearing = 'N' }
                        'N' { $bigboat.bearing = 'E' }
                        'S' { $bigboat.bearing = 'W' }
                    }
                }
                180 {
                    switch ($bigboat.bearing) {
                        'E' { $bigboat.bearing = 'W' }
                        'W' { $bigboat.bearing = 'E' }
                        'N' { $bigboat.bearing = 'S' }
                        'S' { $bigboat.bearing = 'N' }
                    }
                }
                270 {

                    switch ($bigboat.bearing) {
                        'E' { $bigboat.bearing = 'N' }
                        'W' { $bigboat.bearing = 'S' }
                        'N' { $bigboat.bearing = 'W' }
                        'S' { $bigboat.bearing = 'E' }
                    }
                }  
            }
        }
        'F' {
            $bigboat.move($distance)
            switch ($bigboat.bearing) {
                'N' { $bigboat.ns += $distance } #means to move bigboat.north by the given value.
                'S' { $bigboat.ns -= $distance } #means to move south by the given value.
                'E' { $bigboat.ew += $distance } #means to move east by the given value.
                'W' { $bigboat.ew -= $distance } #means to move west by the given value.
            } #means to move forward by the given value in the direction the ship is currently facing.
        }

    }

    #write-host "$($bigboat.bearing) , $($bigboat.ew) , $($bigboat.ns)"
    #write-host "$($bigboat.bearing)  ,n-s $($bigboat.sns) ,-w+e $($bigboat.sew)"
    #write-host "$($bigboat.bearing)  ,n-s $($bigboat.wns) ,-w+e $($bigboat.wew)"
}

$bigboat.manhattan()
$bigboat.part2()