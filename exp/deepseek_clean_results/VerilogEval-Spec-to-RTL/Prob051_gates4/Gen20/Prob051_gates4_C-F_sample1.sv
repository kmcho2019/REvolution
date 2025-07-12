module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // 4-input logic operations using reduction operators
    assign out_and = &in;  // AND of all bits
    assign out_or  = |in;  // OR of all bits
    assign out_xor = ^in;  // XOR of all bits

endmodule