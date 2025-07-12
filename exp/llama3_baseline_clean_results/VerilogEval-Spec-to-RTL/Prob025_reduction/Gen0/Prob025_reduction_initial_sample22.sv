module TopModule(
    input [7:0] in,
    output parity
);

assign parity = ^in;  // Using XOR reduction operator to compute parity

endmodule