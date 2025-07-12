module TopModule(
    input  [7:0] in,     // 8-bit input
    output parity        // 1-bit output
);

assign parity = ^in;    // XOR all bits of 'in' and assign the result to 'parity'

endmodule