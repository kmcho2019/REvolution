module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement B once for subtraction
    wire [63:0] B_comp = ~B;

    // Local generate and propagate for each bit
    wire [63:0] P = A ^ B_comp; // propagate
    wire [63:0] G = A & B_comp; // generate

    // Hierarchical CLA Parameters
    // Using 4-bit blocks => 16 blocks
    // Each block outputs group propagate and generate signals

    wire [15:0] block_P; // Block propagate signals
    wire [15:0] block_G; // Block generate signals

    // Internal carry signals
    wire [64:0] carry;

    assign carry[0] = 1'b1; // initial carry-in (for +1 in two's complement subtraction)

    // --- 4-bit CLA block: compute block generate & propagate, and internal carries
    // block carry generation for bits [4*i +:4]
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : CLA_BLOCK
            wire [3:0] p = P[4*i +:4];
            wire [3:0] g = G[4*i +:4];
            wire c0 = carry[4*i];
            wire c1, c2, c3;

            // Internal carries within 4-bit block using CLA equations:
            assign c1 = g[0] | (p[0] & c0);
            assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
            assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);

            // Compute block propagate: all 4 bits propagate
            assign block_P[i] = &p; // AND all 4 propagate bits
            // Compute block generate: generate within block or propagate all bits and generate carry in
            assign block_G[i] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

            // Assign carries for bits inside block
            assign carry[4*i + 1] = c1;
            assign carry[4*i + 2] = c2;
            assign carry[4*i + 3] = c3;
            // carry[4*i + 4] (next block carry-in) computed by top-level CLA
        end
    endgenerate

    // --- Top level 16-bit CLA to compute carry-in for each 4-bit block
    // carry[4], carry[8], carry[12], ... carry[64]
    // carry[0] is already assigned (1'b1)
    // We compute carry[4*i] for i=1..16 using CLA over block_P and block_G

    // Recursive CLA for 16 blocks, similar to 4-bit CLA for blocks
    wire [15:0] block_carry; // carry-in for each block after first
    assign block_carry[0] = carry[0]; // initial carry-in for first block

    generate
        for (i = 1; i < 16; i = i + 1) begin : BLOCK_CARRY_GEN
            // carry_in to block i is:
            // block_G[i-1] | (block_P[i-1] & carry_in to block i-1)
            assign block_carry[i] = block_G[i-1] | (block_P[i-1] & block_carry[i-1]);
        end
    endgenerate

    // Assign final carries at block boundaries
    generate
        for (i = 1; i < 16; i = i + 1) begin : ASSIGN_BLOCK_CARRY
            assign carry[4*i] = block_carry[i];
        end
    endgenerate

    // Sum bits: result = propagate XOR carry-in
    generate
        for (i = 0; i < 64; i = i + 1) begin : SUM_BITS
            assign result[i] = P[i] ^ carry[i];
        end
    endgenerate

    // Overflow detection:
    // Overflow occurs if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule