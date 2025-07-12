module TopModule (
    input  [7:0] in,
    output       parity
);

    // Compute even parity as XOR reduction of all 8 bits
    assign parity = ^in;

endmodule