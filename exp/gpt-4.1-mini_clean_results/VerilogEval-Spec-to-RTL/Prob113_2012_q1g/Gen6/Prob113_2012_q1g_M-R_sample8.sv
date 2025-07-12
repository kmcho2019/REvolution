module TopModule(
    input  [3:0] x,
    output f
);
    // row = {x[2], x[3]}, col = {x[0], x[1]}
    // Combine row and col bits as row (MSBs) + col (LSBs) to form 4-bit index
    wire [3:0] idx = {x[2], x[3], x[0], x[1]};
    // Karnaugh map packed into a 16-bit vector, where bit position corresponds to idx:
    // bit0 corresponds to idx=0 (row=00, col=00), bit1 to idx=1 (00,01), etc.
    // Using the map:
    // idx (binary) : f
    // 0000 (0): 1
    // 0001 (1): 0
    // 0010 (2): 1
    // 0011 (3): 0
    // 0100 (4): 0
    // 0101 (5): 0
    // 0110 (6): 0
    // 0111 (7): 0
    // 1000 (8): 1
    // 1001 (9): 1
    // 1010 (10): 0
    // 1011 (11): 1
    // 1100 (12): 1
    // 1101 (13): 1
    // 1110 (14): 0
    // 1111 (15): 1
    //
    // Representing bits in order from idx=15 down to 0:
    // idx:     15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
    // f:        1  0  1  1  1  0  1 1 0 0 0 0 0 1 0 1
    // But map indexing in bits should be LSB=idx0 at right side
    // So bit pattern from idx=15 (MSB) to idx=0 (LSB):
    // bit15= f at idx=15 = 1
    // bit14= 0
    // bit13=1
    // bit12=1
    // bit11=1
    // bit10=0
    // bit9=1
    // bit8=1
    // bit7=0
    // bit6=0
    // bit5=0
    // bit4=0
    // bit3=0
    // bit2=1
    // bit1=0
    // bit0=1
    localparam [15:0] LUT = 16'b10111011100000101; // but 17 bits, fix the bit count
    
    // Re-check and reorder carefully to fit 16 bits:
    // Let's write it stepwise:
    // idx: f
    //  0:1
    //  1:0
    //  2:1
    //  3:0
    //  4:0
    //  5:0
    //  6:0
    //  7:0
    //  8:1
    //  9:1
    // 10:0
    // 11:1
    // 12:1
    // 13:1
    // 14:0
    // 15:1
    // Bit order: {15 down to 0} = {f(15), f(14), ..., f(0)}
    // So LUT = 16'b1 0 1 1 1 0 1 1 0 0 0 0 0 1 0 1
    //          bit15 bit14... bit0
    
    localparam [15:0] LUT = 16'b1011101100000101;

    assign f = LUT[idx];

endmodule