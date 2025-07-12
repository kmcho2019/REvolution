module TopModule(
    input  [7:0] in,
    output       parity
);

assign parity = ^in; // Compute the XOR of all bits in the input byte

endmodule