module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimal fusion implementation
    assign out[0] = ^in;  // XOR reduction for LSB (odd count detection)
    
    // Majority detection for MSB expressed clearly
    wire sum01 = in[0] + in[1];
    assign out[1] = (sum01 + in[2]) > 1;
endmodule