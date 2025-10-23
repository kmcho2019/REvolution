module TopModule (
    input [7:0] in,
    output parity
);
    // Compute even parity using XOR reduction
    assign parity = ^in;
endmodule