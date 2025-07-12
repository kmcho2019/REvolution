module TopModule (
    input  [3:0] in,      // 4-bit input
    output       out_and,  // AND reduction output
    output       out_or,   // OR reduction output
    output       out_xor   // XOR reduction output
);
    // Intermediate results for AND operation
    wire and_01 = in[0] & in[1];
    wire and_23 = in[2] & in[3];
    
    // Intermediate results for OR operation
    wire or_01 = in[0] | in[1];
    wire or_23 = in[2] | in[3];
    
    // Intermediate results for XOR operation
    wire xor_01 = in[0] ^ in[1];
    wire xor_23 = in[2] ^ in[3];
    
    // Final outputs
    assign out_and = and_01 & and_23;  // AND all bits
    assign out_or  = or_01 | or_23;    // OR all bits
    assign out_xor = xor_01 ^ xor_23;  // XOR all bits
    
    /* Note: This implementation is functionally identical to the reduction operator version
     * but shows the explicit tree structure of the operations. The synthesis result will
     * be the same as the original implementation.
     */
endmodule