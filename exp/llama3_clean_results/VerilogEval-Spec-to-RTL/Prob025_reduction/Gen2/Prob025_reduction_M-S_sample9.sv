module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // 1-bit parity output
);

assign parity = ^in;  // The ^ operator performs XOR on all bits of the vector

endmodule