module TopModule(
    input  [3:0] in,            // 4-bit input vector
    output       out_and,        // AND of all input bits
    output       out_or,         // OR of all input bits 
    output       out_xor         // XOR of all input bits
);
    // Reduction operators:
    // &in = in[3] & in[2] & in[1] & in[0]
    // |in = in[3] | in[2] | in[1] | in[0]
    // ^in = in[3] ^ in[2] ^ in[1] ^ in[0]
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule