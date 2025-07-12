module TopModule(
    input  [3:0] x,
    output      f
);

    // According to the problem:
    // Rows = x[2] x[3]
    // Columns = x[0] x[1]
    // To get a 4-bit index with rows as the two most significant bits and columns as the two least:
    // We need idx[3:2] = {x[2], x[3]} in the correct order
    // But Karnaugh map rows are listed as x[2] x[3], 
    // so for bits [3:2] = {x[3], x[2]} we reorder as idx = {x[3], x[2], x[1], x[0]}
    // This index treats x[3] as MSB and x[0] as LSB, making counting natural.

    wire [3:0] idx = {x[3], x[2], x[1], x[0]};

    // Construct the 16-bit LUT from the Karnaugh map
    // Karnaugh map (row = x[2] x[3], col = x[0] x[1]):
    //    x[0]x[1]
    // x[2]x[3] 00 01 11 10
    // 00       1  0  0  1
    // 01       0  0  0  0
    // 11       1  1  1  0
    // 10       1  1  0  1

    // Let's write the map explicitly by enumerating all 16 inputs x[3:0]:
    // Inputs x[3:0]: index bits
    // idx = {x[3], x[2], x[1], x[0]} (MSB->LSB)
    //
    // We'll list idx from 0 to 15 and corresponding f values:
    // idx in binary -> {x[3], x[2], x[1], x[0]} -> (row = x[2]x[3], col = x[0]x[1])
    //
    // For each idx (0 to 15), compute row and col bits:
    // row = x[2]x[3] = bits idx[2], idx[3]
    // col = x[0]x[1] = bits idx[0], idx[1]
    //
    // But we must extract row and col from idx bits:
    // idx = {x[3], x[2], x[1], x[0]}
    // idx[3] = x[3], idx[2] = x[2], idx[1] = x[1], idx[0] = x[0]
    //
    // So row = x[2] x[3] = idx[2] idx[3]
    // col = x[0] x[1] = idx[0] idx[1]
    //
    // Now enumerate idx from 0 to 15 (in binary), get row, col, and f:
    //
    // idx | idx[3]x[3] | idx[2]x[2] | idx[1]x[1] | idx[0]x[0] | row (x[2]x[3]) | col (x[0]x[1]) | f
    // ----------------------------------------------------------------------------------------
    // 0 0000: x[3]=0 x[2]=0 x[1]=0 x[0]=0 => row=00 col=00 => f=1
    // 1 0001: x[3]=0 x[2]=0 x[1]=0 x[0]=1 => row=00 col=10 => f=1
    // 2 0010: x[3]=0 x[2]=0 x[1]=1 x[0]=0 => row=00 col=01 => f=0
    // 3 0011: x[3]=0 x[2]=0 x[1]=1 x[0]=1 => row=00 col=11 => f=0
    // 4 0100: x[3]=0 x[2]=1 x[1]=0 x[0]=0 => row=10 col=00 => f=1
    // 5 0101: x[3]=0 x[2]=1 x[1]=0 x[0]=1 => row=10 col=10 => f=0
    // 6 0110: x[3]=0 x[2]=1 x[1]=1 x[0]=0 => row=10 col=01 => f=1
    // 7 0111: x[3]=0 x[2]=1 x[1]=1 x[0]=1 => row=10 col=11 => f=1
    // 8 1000: x[3]=1 x[2]=0 x[1]=0 x[0]=0 => row=01 col=00 => f=0
    // 9 1001: x[3]=1 x[2]=0 x[1]=0 x[0]=1 => row=01 col=10 => f=0
    // 10 1010: x[3]=1 x[2]=0 x[1]=1 x[0]=0 => row=01 col=01 => f=0
    // 11 1011: x[3]=1 x[2]=0 x[1]=1 x[0]=1 => row=01 col=11 => f=0
    // 12 1100: x[3]=1 x[2]=1 x[1]=0 x[0]=0 => row=11 col=00 => f=1
    // 13 1101: x[3]=1 x[2]=1 x[1]=0 x[0]=1 => row=11 col=10 => f=0
    // 14 1110: x[3]=1 x[2]=1 x[1]=1 x[0]=0 => row=11 col=01 => f=1
    // 15 1111: x[3]=1 x[2]=1 x[1]=1 x[0]=1 => row=11 col=11 => f=1
    //
    // Gather f by idx number order:
    // idx: f
    //  0:1
    //  1:1
    //  2:0
    //  3:0
    //  4:1
    //  5:0
    //  6:1
    //  7:1
    //  8:0
    //  9:0
    // 10:0
    // 11:0
    // 12:1
    // 13:0
    // 14:1
    // 15:1
    //
    // Construct binary constant f_table[15:0]:
    // bit15 = f(15) = 1
    // bit14 = f(14) = 1
    // bit13 = f(13) = 0
    // bit12 = f(12) = 1
    // bit11 = f(11) = 0
    // bit10 = f(10) = 0
    // bit9  = f(9)  = 0
    // bit8  = f(8)  = 0
    // bit7  = f(7)  = 1
    // bit6  = f(6)  = 1
    // bit5  = f(5)  = 0
    // bit4  = f(4)  = 1
    // bit3  = f(3)  = 0
    // bit2  = f(2)  = 0
    // bit1  = f(1)  = 1
    // bit0  = f(0)  = 1
    //
    // Binary:  16'b 11 01 0000 1101 0011
    //          bit15..bit0
    //          1 1 0 1 0 0 0 0 1 1 0 1 0 0 1 1 (rechecking)
    //
    // Double-check:
    // bit15=1 (idx15)
    // bit14=1 (idx14)
    // bit13=0 (idx13)
    // bit12=1 (idx12)
    // bit11=0 (idx11)
    // bit10=0 (idx10)
    // bit9=0 (idx9)
    // bit8=0 (idx8)
    // bit7=1 (idx7)
    // bit6=1 (idx6)
    // bit5=0 (idx5)
    // bit4=1 (idx4)
    // bit3=0 (idx3)
    // bit2=0 (idx2)
    // bit1=1 (idx1)
    // bit0=1 (idx0)

    wire [15:0] f_table = 16'b1101000011010011;

    assign f = f_table[idx];

endmodule