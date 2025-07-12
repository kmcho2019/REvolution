module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 4-input AND using reduction operator - most optimal implementation
    assign out_and = &in;
    
    // 4-input OR using reduction operator - most optimal implementation
    assign out_or = |in;
    
    // 4-input XOR using balanced tree structure for optimal timing
    wire xor_lower_bits, xor_upper_bits;
    assign xor_lower_bits = in[0] ^ in[1];
    assign xor_upper_bits = in[2] ^ in[3];
    assign out_xor = xor_lower_bits ^ xor_upper_bits;

endmodule