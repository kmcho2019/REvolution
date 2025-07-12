module TopModule(
    input  [3:0] in,      // 4-bit input
    output       out_and, // AND of all inputs
    output       out_or,  // OR of all inputs
    output       out_xor  // XOR of all inputs
);

    // Using reduction operators for optimal implementation
    assign out_and = &in; // 4-input AND
    assign out_or  = |in; // 4-input OR
    assign out_xor = ^in; // 4-input XOR

endmodule