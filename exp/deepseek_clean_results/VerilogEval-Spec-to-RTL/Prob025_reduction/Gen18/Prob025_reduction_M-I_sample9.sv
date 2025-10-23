module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // Keep the optimal XOR reduction implementation
endmodule