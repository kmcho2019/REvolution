module TopModule (
    input [7:0] in,
    output parity
);
    // Direct XOR reduction for even parity
    assign parity = ^in;
endmodule