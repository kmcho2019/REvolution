module TopModule (
    input  [7:0] in,
    output       parity
);
    // Even parity: XOR all bits of input vector
    assign parity = ^in;
endmodule