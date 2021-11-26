$data = Get-Content .\Day5\part5.txt


class seatid {
    [int32]$seatid
    [int32]$row
    [int32]$seat
    [char[]]$rowdata
    [char[]]$seatdata

    seatid() {}

    seatid([string]$input) {
        $this.rowdata = $input.Substring(0, 7)
        $this.seatdata = $input.Substring(7, 3)
        $this.getrow()
        $this.getseat()
        $this.calcseatid()

    }
    [void] calcseatid () {
        $this.seatid = ($this.row * 8)+$this.seat
    }

    [void] getrow() {
        #rows 128
        #columns 8
        
        [int32[]]$rows = 0..128 | % { $_ }
        [int32]$top = 128
        [int32]$bot = 0
        [char[]]$in = $this.rowdata

        for ($i = 0; $i -lt $in.Count; $i++) {
    
            if ($in[$i] -eq 'B') {
                $current = (($rows.count - 1) / 2)
                $rows = $rows[$current..$top]
                $top = $rows.count
            }

            else {
                $current = (($rows.count - 1) / 2)
                $rows = $rows[$bot..$current]
                $top = $rows.count
            }

            if (($rows.count -eq 2) -and ($in[$i] -eq 'B')) {
                $this.row = $rows[1]-1
            }
            elseif (($rows.count -eq 2) -and ($in[$i] -eq 'F')) { $this.row = $rows[0] }
        }
    }
    [void] getseat() {
        
    [int32[]]$column = 0..8| % {$_}
    [int32]$top = 8
    [int32]$bot = 0
    [char[]]$in = $this.seatdata

    for ($i = 0; $i -lt $in.Count; $i++) {
    
    if ($in[$i] -eq 'R') {
    $current = (($column.count-1)/2)
    $column = $column[$current..$top]
    $top = $column.count
    }

    else {
        $current = (($column.count-1)/2)
        $column = $column[$bot..$current]
        $top = $column.count
    }

    if (($column.count -eq 2) -and ($in[$i] -eq 'R')) {
        $this.seat = $column[1]-1
    }
    elseif (($column.count -eq 2) -and ($in[$i] -eq 'L')) {$this.seat = $column[0]}
}

    }
}

#Lösning av bla p2vb
# Gör om FLBR till binärt sedan konvertera det till decimalt. Det ger seatid direkt.
# $data | %{[convert]::ToInt32(($_ -replace '[FL]', '0' -replace '[BR]', '1'), 2)} 
#

#testdata
#"BFFFBBFRRR","FFFBBBFRRR","BBFFBBFRLL" | %{[seatid]::new($_)} | sort seatid -Descending | select -first 1 -ExpandProperty seatid

$seats = $data | %{[seatid]::new($_)}

$seats | sort seatid -Descending | select -first 1 -ExpandProperty seatid


#part 2
$f,$l = $seats.seatid | sort | select -first 1 -last 1

[int32[]]$my = $f..$l |% {$_}

Compare-Object -ReferenceObject $seats.seatid -DifferenceObject $my | Select-Object -ExpandProperty Inputobject