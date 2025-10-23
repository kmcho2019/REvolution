module TopModule (
    input  [7:0] in,
    output       parity
);
    // Even parity is the XOR of all input bits
    assign parity = ^in;
endmodule