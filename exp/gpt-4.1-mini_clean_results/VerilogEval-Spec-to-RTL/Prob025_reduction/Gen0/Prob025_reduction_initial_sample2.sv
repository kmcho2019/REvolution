module TopModule (
    input  [7:0] in,
    output parity
);
    assign parity = ^in;  // XOR reduction for even parity
endmodule