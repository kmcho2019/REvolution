module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in;  // Using reduction AND operator
assign out_or  = |in;  // Using reduction OR operator
assign out_xor = ^in;  // Using reduction XOR operator

endmodule