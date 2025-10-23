module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly use the built-in reduction XOR operator for 8-bit input parity
    assign parity = ^in;
endmodule