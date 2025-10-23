module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Direct reduction operators to compute outputs
    assign out_and = &in;  // AND of all 4 bits
    assign out_or  = |in;  // OR of all 4 bits
    assign out_xor = ^in;  // XOR of all 4 bits

endmodule