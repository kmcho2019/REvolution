module TopModule (
    input [7:0] in,
    output parity
);
    // Even parity = XOR of all bits (in[0]^in[1]^...^in[7])
    assign parity = ^in;  // Optimal implementation with documentation
endmodule