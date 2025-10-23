module TopModule (
    input [7:0] in,
    output parity
);
    // Even parity calculation: XOR of all input bits
    assign parity = ^in;
endmodule