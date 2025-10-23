module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity as XOR of all bits
    assign parity = ^in;
endmodule