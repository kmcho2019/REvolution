module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // Single XOR reduction operation
endmodule