module TopModule(
    input  [3:0] x,
    output      f
);

    // Reorder x bits to form index: {x[2], x[3], x[0], x[1]}
    // According to the problem, rows = x[2]x[3], cols = x[0]x[1].
    // We'll use this exact order for indexing the LUT.
    wire [3:0] idx = {x[2], x[3], x[0], x[1]};

    // Construct a 16-bit constant representing the Karnaugh map values:
    // bit positions correspond to idx from 0 to 15:
    // idx: value from Karnaugh map:
    //  0b0000 (row=00 col=00) = 1
    //  0b0001 (row=00 col=01) = 0
    //  0b0010 (row=00 col=10) = 1
    //  0b0011 (row=00 col=11) = 0
    //
    //  0b0100 (row=01 col=00) = 0
    //  0b0101 (row=01 col=01) = 0
    //  0b0110 (row=01 col=10) = 0
    //  0b0111 (row=01 col=11) = 0
    //
    //  0b1000 (row=10 col=00) = 1
    //  0b1001 (row=10 col=01) = 1
    //  0b1010 (row=10 col=10) = 1
    //  0b1011 (row=10 col=11) = 0
    //
    //  0b1100 (row=11 col=00) = 1
    //  0b1101 (row=11 col=01) = 1
    //  0b1110 (row=11 col=10) = 0
    //  0b1111 (row=11 col=11) = 1

    // Creating f_table from LSB (idx=0) to MSB (idx=15):
    // bits =  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    // idx =  1111 ..                  ..                    0000
    // vals =  1   0  1  1  0  1  1  1  0  0  0  0  0  1  0  1
    // Wait, carefully writing out from the map:
    // idx=0  = 1
    // idx=1  = 0
    // idx=2  = 1
    // idx=3  = 0
    // idx=4  = 0
    // idx=5  = 0
    // idx=6  = 0
    // idx=7  = 0
    // idx=8  = 1
    // idx=9  = 1
    // idx=10 = 1
    // idx=11 = 0
    // idx=12 = 1
    // idx=13 = 1
    // idx=14 = 0
    // idx=15 = 1
    //
    // So f_table in binary (MSB to LSB) = bit15..bit0
    // bit15=1,14=0,13=1,12=1,11=0,10=1,9=1,8=1,7=0,6=0,5=0,4=0,3=0,2=1,1=0,0=1
    // binary: 1011_01011_0000_101
    // Let's pad to 16 bits:
    // 16'b1011_0101_1000_0101

    wire [15:0] f_table = 16'b1011010110000101;

    assign f = f_table[idx];

endmodule