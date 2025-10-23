module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

assign out_and = &in;  // reduction AND of all bits in input
assign out_or  = |in;  // reduction OR of all bits in input
assign out_xor = ^in;  // reduction XOR of all bits in input

endmodule