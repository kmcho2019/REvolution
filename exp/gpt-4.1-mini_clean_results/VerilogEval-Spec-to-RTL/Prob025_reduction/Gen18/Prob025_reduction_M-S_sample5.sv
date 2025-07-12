module TopModule (
    input  [7:0] in,
    output       parity
);
    // Even parity is XOR reduction of all bits
    assign parity = ^in;
endmodule