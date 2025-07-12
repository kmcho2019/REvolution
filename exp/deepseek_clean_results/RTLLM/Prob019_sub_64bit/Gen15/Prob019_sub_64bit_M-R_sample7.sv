module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry_chain;
    
    // Initialize carry_chain[-1] to 1 for the +1 in two's complement
    wire carry_in = 1'b1;
    
    // Full adder implementation for all 64 bits
    assign {carry_chain[0], result[0]} = A[0] + B_comp[0] + carry_in;
    
    genvar i;
    generate
        for (i=1; i<64; i=i+1) begin : sub_adder
            assign {carry_chain[i], result[i]} = A[i] + B_comp[i] + carry_chain[i-1];
        end
    endgenerate

    // Overflow detection signals
    wire signs_differ = A[63] ^ B[63];
    wire result_sign_differs = A[63] ^ result[63];
    
    // Overflow occurs when signs differ and result sign differs from A's sign
    assign overflow = signs_differ & result_sign_differs;

    /* Implementation Notes:
     * 1. Uniform implementation for all bits by initializing carry_in
     * 2. Clear separation of subtraction and overflow logic
     * 3. More readable signal names for better maintainability
     * 4. Same efficient implementation as original but with cleaner structure
     */
endmodule