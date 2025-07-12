module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in;  // Reduction AND operator (&) on input vector in
assign out_or  = |in;  // Reduction OR operator (|) on input vector in
assign out_xor = ^in;  // Reduction XOR operator (^) on input vector in

endmodule