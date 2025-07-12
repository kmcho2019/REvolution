module TopModule(
    input  [3:0] in,       // 4-bit input
    output       out_and,  // 4-input AND
    output       out_or,   // 4-input OR
    output       out_xor   // 4-input XOR
);

    // Using Verilog reduction operators for optimal implementation
    assign out_and = &in;  // AND all bits
    assign out_or  = |in;  // OR all bits
    assign out_xor = ^in;  // XOR all bits

endmodule