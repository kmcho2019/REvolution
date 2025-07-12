module TopModule (
    input  [7:0] in,
    output      parity
);
    // Compute even parity as the XOR of all 8 input bits using reduction XOR operator
    assign parity = ^in;
endmodule