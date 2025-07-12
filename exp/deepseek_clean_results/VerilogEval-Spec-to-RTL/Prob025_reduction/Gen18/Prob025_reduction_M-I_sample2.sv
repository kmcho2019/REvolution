module TopModule (
    input [7:0] in,
    output parity
);
    // Optimal XOR reduction for even parity
    assign parity = ^in;
endmodule