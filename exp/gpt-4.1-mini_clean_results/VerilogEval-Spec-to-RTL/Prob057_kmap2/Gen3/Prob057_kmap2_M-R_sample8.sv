module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Truth table bits where LSB corresponds to minterm 0 (a=0,b=0,c=0,d=0)
    // Bit index = {c,d,a,b} as per mapping (row=cd, col=ab)
    // According to the problem, ones at minterms: 0,1,2,4,6,8,9,13,14,15
    // Binary: b15 b14 b13 b12 b11 b10 b9 b8 b7 b6 b5 b4 b3 b2 b1 b0
    //        =  1    1   1   0   0  0  1 1  0 1  0 1  0 1  1 1 (rearranged per minterms)
    // From the example, minterms with 1: 0,1,2,4,6,8,9,13,14,15
    // So setting bits accordingly:
    localparam [15:0] LUT = 16'b1110011010010011;

    wire [3:0] idx = {c, d, a, b};

    assign out = LUT[idx];

endmodule