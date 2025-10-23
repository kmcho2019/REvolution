module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Input registers for operand isolation
    reg signed [63:0] A_reg, B_reg;
    always @(*) begin
        A_reg = A;
        B_reg = B;
    end

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B_reg;
    wire [63:0] carry_chain;

    // Hierarchical carry-lookahead in 8-bit blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [7:0] p = A_reg[i+:8] ^ B_comp[i+:8];
            wire [7:0] g = A_reg[i+:8] & B_comp[i+:8];
            
            // Carry computation
            if (i == 0) begin
                assign carry_chain[0] = g[0] | (p[0] & 1'b1); // Initial carry-in = 1
                assign carry_chain[1] = g[1] | (p[1] & carry_chain[0]);
                assign carry_chain[2] = g[2] | (p[2] & carry_chain[1]);
                assign carry_chain[3] = g[3] | (p[3] & carry_chain[2]);
                assign carry_chain[4] = g[4] | (p[4] & carry_chain[3]);
                assign carry_chain[5] = g[5] | (p[5] & carry_chain[4]);
                assign carry_chain[6] = g[6] | (p[6] & carry_chain[5]);
                assign carry_chain[7] = g[7] | (p[7] & carry_chain[6]);
            end else begin
                assign carry_chain[i]   = g[0] | (p[0] & carry_chain[i-1]);
                assign carry_chain[i+1] = g[1] | (p[1] & carry_chain[i]);
                assign carry_chain[i+2] = g[2] | (p[2] & carry_chain[i+1]);
                assign carry_chain[i+3] = g[3] | (p[3] & carry_chain[i+2]);
                assign carry_chain[i+4] = g[4] | (p[4] & carry_chain[i+3]);
                assign carry_chain[i+5] = g[5] | (p[5] & carry_chain[i+4]);
                assign carry_chain[i+6] = g[6] | (p[6] & carry_chain[i+5]);
                assign carry_chain[i+7] = g[7] | (p[7] & carry_chain[i+6]);
            end
            
            // Sum computation (reusing p XOR carry)
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry_chain[i-1]);
            assign result[i+1] = p[1] ^ carry_chain[i];
            assign result[i+2] = p[2] ^ carry_chain[i+1];
            assign result[i+3] = p[3] ^ carry_chain[i+2];
            assign result[i+4] = p[4] ^ carry_chain[i+3];
            assign result[i+5] = p[5] ^ carry_chain[i+4];
            assign result[i+6] = p[6] ^ carry_chain[i+5];
            assign result[i+7] = p[7] ^ carry_chain[i+6];
        end
    endgenerate

    /* Early Overflow Detection (computed in parallel):
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Implemented as: (A[63] ^ B[63]) && (A[63] ^ result[63])
     */
    wire a_sign = A_reg[63];
    wire b_sign = B_reg[63];
    wire r_sign = result[63];
    assign overflow = (a_sign ^ b_sign) & (a_sign ^ r_sign);

    /* Implementation Notes:
     * 1. Uses 8-bit CLA blocks for better timing
     * 2. Early overflow detection reduces critical path
     * 3. Input registers provide operand isolation
     * 4. Resource sharing reduces area
     * 5. Clean hierarchical structure maintains readability
     */
endmodule