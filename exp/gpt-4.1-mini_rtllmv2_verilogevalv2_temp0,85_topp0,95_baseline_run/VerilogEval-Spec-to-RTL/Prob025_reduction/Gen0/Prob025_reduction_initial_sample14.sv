module TopModule(
    input  [7:0] in,
    output parity
);

assign parity = ^in; // XOR reduction of all 8 bits

endmodule