module TopModule (
    input  [7:0] in,
    output       parity
);
    assign parity = ^in;  // continuous assignment using reduction XOR for optimal even parity calculation
endmodule