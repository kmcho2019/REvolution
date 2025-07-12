module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // Direct XOR reduction for even parity
endmodule