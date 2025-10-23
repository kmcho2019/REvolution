module TopModule (
    input  [7:0] in,
    output       parity
);

    assign parity = ^in;  // Direct XOR reduction over all 8 bits for even parity

endmodule