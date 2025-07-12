module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in;  // Reduction AND operation on all bits of in
assign out_or  = |in;  // Reduction OR operation on all bits of in
assign out_xor = ^in;  // Reduction XOR operation on all bits of in

endmodule