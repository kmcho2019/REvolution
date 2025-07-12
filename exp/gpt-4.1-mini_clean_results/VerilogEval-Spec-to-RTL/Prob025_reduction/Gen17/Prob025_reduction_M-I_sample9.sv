module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly assign parity as XOR reduction of 8-bit input for even parity
    assign parity = ^in;
endmodule