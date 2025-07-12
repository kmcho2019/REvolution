module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly assign parity as XOR of all 8 input bits
    assign parity = ^in;
endmodule