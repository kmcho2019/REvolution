module TopModule (
    input [7:0] in,
    output parity
);
    // Simple XOR reduction for even parity
    assign parity = ^in;
endmodule