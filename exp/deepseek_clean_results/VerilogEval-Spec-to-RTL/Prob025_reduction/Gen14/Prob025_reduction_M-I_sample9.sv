module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // Optimal XOR reduction implementation
endmodule