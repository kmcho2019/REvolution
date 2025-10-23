module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in; // Reduction AND operator
assign out_or  = |in;  // Reduction OR operator
assign out_xor = ^in;  // Reduction XOR operator

endmodule