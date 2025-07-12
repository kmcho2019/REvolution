module TopModule (
    input [7:0] in,
    output parity
);

    assign parity = ^in;  // Bitwise XOR of all input bits

endmodule