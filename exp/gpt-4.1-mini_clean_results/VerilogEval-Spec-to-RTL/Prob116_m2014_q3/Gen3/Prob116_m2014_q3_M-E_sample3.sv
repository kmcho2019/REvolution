module TopModule(
    input  [3:0] x,
    output      f
);

    // We interpret inputs as: x[3]x[2]x[1]x[0]
    // Build a 16-bit lookup table where bit position equals input value (0..15)
    // Bit 0 corresponds to x=4'b0000, bit 15 to x=4'b1111

    // From the Karnaugh map (rows x[3]x[0], columns x[1]x[2]), fill in f values:
    // Let's enumerate all 16 inputs (x[3],x[2],x[1],x[0]) and assign f:
    //
    // x[3] x[2] x[1] x[0] : f (from the Karnaugh map)
    //  0     0    0    0   : d => 0
    //  0     0    0    1   : 0
    //  0     0    1    0   : d => 0
    //  0     0    1    1   : d => 0
    //
    //  0     1    0    0   : 0
    //  0     1    0    1   : d => 0
    //  0     1    1    0   : 1
    //  0     1    1    1   : 0
    //
    //  1     1    0    0   : 1
    //  1     1    0    1   : 1
    //  1     1    1    0   : d => 0
    //  1     1    1    1   : d => 0
    //
    //  1     0    0    0   : 1
    //  1     0    0    1   : 1
    //  1     0    1    0   : 0
    //  1     0    1    1   : d => 0

    // Let's explicitly write the 16-bit constant:
    // Index = {x3,x2,x1,x0}
    // Bit index: 15 (1111) ... 0 (0000)

    // Mapping:
    // idx: x3x2x1x0 : f
    // 0: 0000 : 0 (d)
    // 1: 0001 : 0
    // 2: 0010 : 0 (d)
    // 3: 0011 : 0 (d)
    // 4: 0100 : 0
    // 5: 0101 : 0 (d)
    // 6: 0110 : 1
    // 7: 0111 : 0
    // 8: 1000 : 1
    // 9: 1001 : 1
    // 10:1010 : 0
    // 11:1011 : 0
    // 12:1100 : 1
    // 13:1101 : 1
    // 14:1110 : 0 (d)
    // 15:1111 : 0 (d)

    // Binary vector for f (bit 15 down to bit 0): 
    // Bit15=0
    // Bit14=0
    // Bit13=1
    // Bit12=1
    // Bit11=0
    // Bit10=0
    // Bit9=1
    // Bit8=1
    // Bit7=0
    // Bit6=1
    // Bit5=0
    // Bit4=0
    // Bit3=0
    // Bit2=0
    // Bit1=0
    // Bit0=0

    // So as a 16-bit binary: 0011 0011 0100 0000
    // In hex: 0x3340

    localparam [15:0] LUT = 16'h3340;

    assign f = LUT[x];

endmodule