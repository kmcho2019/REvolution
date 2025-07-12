module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity using the reduction XOR operator
    assign parity = ^in;
endmodule