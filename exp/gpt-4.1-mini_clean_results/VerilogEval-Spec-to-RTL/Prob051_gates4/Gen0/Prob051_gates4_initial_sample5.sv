module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    assign out_and = &in;  // Reduction AND of all bits in
    assign out_or  = |in;  // Reduction OR of all bits in
    assign out_xor = ^in;  // Reduction XOR of all bits in

endmodule