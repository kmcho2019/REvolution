module TopModule(
    input [7:0] in,
    output parity
);

assign parity = ^in; // Using the reduce operator to XOR all bits of the input vector

endmodule