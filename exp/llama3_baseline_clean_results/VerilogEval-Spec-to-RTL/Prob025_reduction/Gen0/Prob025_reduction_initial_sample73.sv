module TopModule(
    input  [7:0] in,     // 8-bit input byte
    output       parity // 1-bit parity output
);

    assign parity = ^in; // XOR all bits of the input byte

endmodule