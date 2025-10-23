module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // 4-input logic gates using reduction operators
    assign out_and = &in;  // AND all bits
    assign out_or  = |in;  // OR all bits
    assign out_xor = ^in;  // XOR all bits

endmodule