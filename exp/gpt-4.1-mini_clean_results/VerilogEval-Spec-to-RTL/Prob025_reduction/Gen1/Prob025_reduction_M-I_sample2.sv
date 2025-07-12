module TopModule (
    input  [7:0] in,
    output wire  parity
);
    assign parity = ^in;  // XOR reduction of all bits for even parity
endmodule