module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    assign out_and = &in;  // reduction AND of all 4 bits
    assign out_or  = |in;  // reduction OR of all 4 bits
    assign out_xor = ^in;  // reduction XOR of all 4 bits

endmodule