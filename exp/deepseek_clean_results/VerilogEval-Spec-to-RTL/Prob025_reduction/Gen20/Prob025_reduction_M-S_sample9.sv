module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // Reduction XOR for even parity
endmodule