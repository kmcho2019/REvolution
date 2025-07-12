module TopModule(
    input [7:0] in,  // 8-bit input
    output parity    // 1-bit parity output
);

    assign parity = ^in;  // Compute XOR of all 8 bits and assign to parity

endmodule