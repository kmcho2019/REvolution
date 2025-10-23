module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly assign parity as the reduction XOR of all input bits
    assign parity = ^in;
endmodule