module TopModule (
    input  [3:0] in,      // 4-bit input
    output       out_and,  // AND reduction output
    output       out_or,   // OR reduction output
    output       out_xor   // XOR reduction output
);
    // Direct reduction operations
    assign out_and = &in;  // AND all bits
    assign out_or  = |in;  // OR all bits
    assign out_xor = ^in;  // XOR all bits
endmodule