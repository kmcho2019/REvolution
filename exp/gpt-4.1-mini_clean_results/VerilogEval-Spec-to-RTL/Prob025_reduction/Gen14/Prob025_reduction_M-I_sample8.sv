module TopModule (
    input  [7:0] in,
    output       parity
);
    // Even parity: XOR all bits of input
    assign parity = ^in;
endmodule