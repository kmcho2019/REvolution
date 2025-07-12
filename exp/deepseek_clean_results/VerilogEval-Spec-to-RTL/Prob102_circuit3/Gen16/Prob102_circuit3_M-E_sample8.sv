module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // 16-bit mask where each bit corresponds to input combination abcd
    // The pattern matches the truth table from the waveform:
    // q is 1 when (a|b) & (c|d) is true
    wire [15:0] lut_mask = 16'b0000_0111_0111_1111;
    
    // Create 4-bit address from inputs
    wire [3:0] address = {a, b, c, d};
    
    // Output is the corresponding bit from the LUT mask
    assign q = lut_mask[address];

endmodule