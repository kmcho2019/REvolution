module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire [15:0] lut = 16'b1110110111100111;
    // Index is {d,c,b,a}
    // From input combination (d,c,b,a):
    // bit0 = m0 = 1
    // bit1 = m1 = 1
    // bit2 = m2 = 1
    // bit3 = m3 = 0
    // bit4 = m4 = 1
    // bit5 = m5 = 0
    // bit6 = m6 = 1
    // bit7 = m7 = 1
    // bit8 = m8 = 1
    // bit9 = m9 = 1
    // bit10= m10= 0
    // bit11= m11= 0
    // bit12= m12= 0
    // bit13= m13= 1
    // bit14= m14= 1
    // bit15= m15= 1

    assign out = lut[{d,c,b,a}];

endmodule