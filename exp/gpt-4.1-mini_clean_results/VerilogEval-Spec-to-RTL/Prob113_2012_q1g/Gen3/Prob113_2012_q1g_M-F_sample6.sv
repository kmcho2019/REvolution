module TopModule(
    input  [3:0] x,
    output      f
);

    // Construct index as {x[3], x[2], x[1], x[0]}
    wire [3:0] idx = {x[3], x[2], x[1], x[0]};

    // Karnaugh map (from problem), reinterpreted with:
    // rows = x[3]x[2] (MSBs), cols = x[1]x[0] (LSBs)
    //
    // Row\Col: 00  01  11  10  (cols: x[1]x[0])
    // 00       1   0   0   1   (row=00 => x[3]=0,x[2]=0)
    // 01       0   0   0   0   (row=01 => x[3]=0,x[2]=1)
    // 11       1   1   1   0   (row=11 => x[3]=1,x[2]=1)
    // 10       1   1   0   1   (row=10 => x[3]=1,x[2]=0)
    //
    // So the 16 entries indexed by {x[3],x[2],x[1],x[0]} are:
    // idx (bin) : f
    // 0000 (0) = row=00 col=00 => 1
    // 0001 (1) = row=00 col=01 => 0
    // 0010 (2) = row=00 col=10 => 1
    // 0011 (3) = row=00 col=11 => 0
    //
    // 0100 (4) = row=01 col=00 => 0
    // 0101 (5) = row=01 col=01 => 0
    // 0110 (6) = row=01 col=10 => 0
    // 0111 (7) = row=01 col=11 => 0
    //
    // 1000 (8) = row=10 col=00 => 1
    // 1001 (9) = row=10 col=01 => 1
    // 1010 (10)= row=10 col=10 => 0
    // 1011 (11)= row=10 col=11 => 1
    //
    // 1100 (12)= row=11 col=00 => 1
    // 1101 (13)= row=11 col=01 => 1
    // 1110 (14)= row=11 col=10 => 1
    // 1111 (15)= row=11 col=11 => 0
    //
    // Construct f_table bits from idx=15..0 (MSB to LSB):
    // bit15=0, 14=1, 13=1, 12=1, 11=1, 10=0, 9=1, 8=1,
    // bit7=0, 6=0, 5=0, 4=0, 3=0, 2=1, 1=0, 0=1
    //
    // Binary literal: 16'b0_1111_0110_0000_101
    // Let's write all bits:
    // bit15:0
    // bit14:1
    // bit13:1
    // bit12:1
    // bit11:1
    // bit10:0
    // bit9:1
    // bit8:1
    // bit7:0
    // bit6:0
    // bit5:0
    // bit4:0
    // bit3:0
    // bit2:1
    // bit1:0
    // bit0:1

    wire [15:0] f_table = 16'b0111101100000101;

    assign f = f_table[idx];

endmodule