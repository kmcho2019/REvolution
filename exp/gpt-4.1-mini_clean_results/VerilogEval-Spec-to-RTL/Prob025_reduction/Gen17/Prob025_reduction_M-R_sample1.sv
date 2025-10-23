module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity as the reduction XOR of all input bits
    assign parity = ^in;
endmodule