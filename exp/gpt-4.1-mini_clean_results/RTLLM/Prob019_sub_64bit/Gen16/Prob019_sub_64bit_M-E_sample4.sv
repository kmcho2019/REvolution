module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Compute two's complement of B (B_comp = ~B + 1)
    wire [63:0] B_comp = ~B;

    // Internal signals for propagate and generate at 64-bit and block levels
    wire [63:0] P;  // propagate bits: A ^ B_comp
    wire [63:0] G;  // generate bits: A & B_comp
    wire [4:0]  C;  // carry for block boundaries: C[0] = initial carry in (1 for subtraction)

    assign C[0] = 1'b1; // Initial carry-in is 1 for two's complement addition (~B + 1)

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bit_gen
            assign P[i] = A[i] ^ B_comp[i];
            assign G[i] = A[i] & B_comp[i];
        end
    endgenerate

    // Divide into four 16-bit blocks for hierarchical carry-lookahead
    // Compute block propagate and generate
    wire [3:0] blockP;
    wire [3:0] blockG;

    // Block-level propagate: all 16 P bits ANDed
    assign blockP[0] = &P[15:0];
    assign blockP[1] = &P[31:16];
    assign blockP[2] = &P[47:32];
    assign blockP[3] = &P[63:48];

    // Block-level generate: G_block = G_high + (P_high * G_low) + ... for 16 bits
    // Implement blockG as any carry generated within the block or from lower bits

    // To compute blockG we use carry-lookahead within the block:
    // For the block, G_block = G[15] + P[15]*G[14] + P[15]*P[14]*G[13] + ... + P[15:1]*G[0]
    // This is complex to fully unroll; instead, approximate with hierarchical approach:
    // Compute carry-out of block 0: carry into bit 16
    wire c16;
    assign c16 = compute_carry(P[15:0], G[15:0], C[0]);
    assign blockG[0] = c16;

    wire c32;
    assign c32 = compute_carry(P[31:16], G[31:16], c16);
    assign blockG[1] = c32;

    wire c48;
    assign c48 = compute_carry(P[47:32], G[47:32], c32);
    assign blockG[2] = c48;

    wire c64;
    assign c64 = compute_carry(P[63:48], G[63:48], c48);
    assign blockG[3] = c64;

    // Block carries for next level (C[1] to C[4]) are the carry outs at each 16-bit boundary
    assign C[1] = c16;
    assign C[2] = c32;
    assign C[3] = c48;
    assign C[4] = c64;

    // Generate sum bits: sum = P ^ C (carry-in at each bit)
    // Create carry vector for each bit
    wire [64:0] carry_bits;
    assign carry_bits[0] = 1'b1; // initial carry-in

    // Compute carry bits for all bits using P, G, and previous carries inside compute_carry
    wire [63:0] sum_bits;

    // For each 16-bit block, generate carry bits and sum bits
    generate
        for (i=0; i<4; i=i+1) begin : block_sum
            wire [15:0] blockP_i = P[(i*16)+15 -:16];
            wire [15:0] blockG_i = G[(i*16)+15 -:16];
            wire [15:0] block_sum;
            wire carry_in_block = C[i];
            wire carry_out_block;

            assign block_sum = compute_sum(blockP_i, blockG_i, carry_in_block, carry_out_block);

            assign sum_bits[(i*16)+15 -:16] = block_sum;
        end
    endgenerate

    assign result = sum_bits;

    // Overflow detection:
    // For subtraction (A - B), overflow occurs when sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);


    // Function to compute carry-out for a 16-bit block
    function automatic compute_carry;
        input [15:0] p;
        input [15:0] g;
        input        cin;
        reg [16:0] c_internal;
        integer idx;
    begin
        c_internal[0] = cin;
        for (idx = 0; idx < 16; idx = idx + 1) begin
            c_internal[idx+1] = g[idx] | (p[idx] & c_internal[idx]);
        end
        compute_carry = c_internal[16];
    end
    endfunction

    // Function to compute sum for 16-bit block and propagate carry-out
    function automatic [15:0] compute_sum;
        input [15:0] p;
        input [15:0] g;
        input        cin;
        output       cout;
        reg [16:0] c_internal;
        integer idx;
        reg [15:0] sum_local;
    begin
        c_internal[0] = cin;
        for (idx = 0; idx < 16; idx = idx + 1) begin
            c_internal[idx+1] = g[idx] | (p[idx] & c_internal[idx]);
            sum_local[idx] = p[idx] ^ c_internal[idx];
        end
        cout = c_internal[16];
        compute_sum = sum_local;
    end
    endfunction

endmodule