module TopModule (
    input in1,
    input in2,
    output out
);
    // 4-bit LUT configuration for all possible 2-input combinations
    // For function out = in1 & ~in2, the truth table is:
    // in2 in1 | out
    //  0   0  |  0
    //  0   1  |  1
    //  1   0  |  0
    //  1   1  |  0
    reg [3:0] lut_config = 4'b0100; // Stored in order 00,01,10,11
    
    // Use inputs as index into LUT
    assign out = lut_config[{in2, in1}];
endmodule