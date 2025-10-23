module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // LSB: XOR remains the most efficient for odd count detection
    assign out[0] = ^in;  // Compact XOR reduction
    
    // MSB: Optimized majority detection using balanced logic
    assign out[1] = (in[0] & in[1]) | (in[2] & (in[0] | in[1]));

endmodule