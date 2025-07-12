module TopModule (
    input  [7:0] in,
    output       parity
);
    assign parity = ^in;  // Continuous assignment for even parity using reduction XOR
endmodule