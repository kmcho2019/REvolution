module TopModule (
    input  [7:0] in,
    output       parity
);
    // Even parity is XOR of all input bits
    assign parity = ^in;
endmodule