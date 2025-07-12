module TopModule (
    input in,
    output out
);
    // Implement NOT using a 2-input LUT
    // Inputs: enable (tied high) and actual input
    // LUT truth table:
    // enable | in | out
    //   0    |  X |  0  (disabled)
    //   1    |  0 |  1  (inverted)
    //   1    |  1 |  0  (inverted)
    wire enable = 1'b1;  // LUT always enabled
    
    assign out = (enable & ~in) | (~enable & 1'b0);
endmodule