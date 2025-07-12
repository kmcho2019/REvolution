module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // LUT vector indexed by inputs {a,b,c,d}
    // Index: a b c d
    // Map input combinations to q:
    //  a b c d | q
    //  0 0 0 0 | 0
    //  0 0 0 1 | 0
    //  0 0 1 0 | 1
    //  0 0 1 1 | 1
    //  0 1 0 0 | 1
    //  0 1 0 1 | 1
    //  0 1 1 0 | 1
    //  0 1 1 1 | 1
    //  1 0 0 0 | 0
    //  1 0 0 1 | 0
    //  1 0 1 0 | 1
    //  1 0 1 1 | 1
    //  1 1 0 0 | 1
    //  1 1 0 1 | 1
    //  1 1 1 0 | 1
    //  1 1 1 1 | 1

    // Binary string for q, LSB = index 0 (a=0,b=0,c=0,d=0)
    // Indices from 0 to 15 correspond to 4-bit input: a,b,c,d
    // Create bit vector in hex form: bit0 is index 0 (a=0,b=0,c=0,d=0)
    // From the table above:
    // index: q
    // 0:0,1:0,2:1,3:1,4:1,5:1,6:1,7:1,8:0,9:0,10:1,11:1,12:1,13:1,14:1,15:1
    // q vector bits from bit 15 down to bit 0 = 1111_1111_1100_1100 binary = 0xFCC
    // But Verilog uses LSB index 0 = least significant bit
    // So reversed bits: bit0=0, bit1=0, bit2=1, bit3=1, bit4=1, bit5=1, bit6=1, bit7=1, bit8=0, bit9=0, bit10=1, bit11=1, bit12=1, bit13=1, bit14=1, bit15=1
    // So hex vector: 16'b1111111111001100 = 16'hFFC C
    
    wire [15:0] lut = 16'b1111111111001100;

    assign q = lut[{a,b,c,d}];

endmodule