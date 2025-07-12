module TopModule(
    input  [7:0] in,
    output parity
);

assign parity = ^in;  // XOR all 8 bits of 'in' to calculate the parity

endmodule