module TopModule (
    input [7:0] in,
    output parity
);
    // Optimal even parity calculation using XOR reduction
    assign parity = ^in;
endmodule