module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // Even parity: XOR of all input bits
endmodule