module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity using reduction XOR operator
    assign parity = ^in;
endmodule