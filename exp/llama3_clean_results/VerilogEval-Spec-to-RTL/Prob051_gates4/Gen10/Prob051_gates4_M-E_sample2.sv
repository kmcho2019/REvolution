module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &in; // AND reduction across all bits of in
    assign out_or  = |in;  // OR reduction across all bits of in
    assign out_xor = ^in;  // XOR reduction across all bits of in
endmodule