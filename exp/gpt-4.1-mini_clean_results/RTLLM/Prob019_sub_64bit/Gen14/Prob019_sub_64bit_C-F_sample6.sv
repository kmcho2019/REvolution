module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Step 1: Compute bitwise complement of B for two's complement subtraction
    wire [63:0] B_neg = ~B;

    // Step 2: Partition A and B_neg into 8-bit chunks
    wire [7:0] A_chunks [7:0];
    wire [7:0] B_chunks [7:0];
    genvar idx;
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : part_inputs
            assign A_chunks[idx] = A[8*idx +: 8];
            assign B_chunks[idx] = B_neg[8*idx +: 8];
        end
    endgenerate

    // Step 3: Declare propagate and generate signals for each 8-bit CLA block
    wire [7:0] P_blocks; // block propagate signals
    wire [7:0] G_blocks; // block generate signals

    // Step 4: Declare carry signals between blocks
    wire [8:0] carry;
    assign carry[0] = 1'b1; // initial carry-in = 1 for two's complement subtraction

    // Step 5: Instantiate 8-bit CLA blocks to compute sums and intra-block P/G
    wire [7:0] sum_blocks [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_blocks
            cla_8bit_sub u_cla8 (
                .A      (A_chunks[i]),
                .B      (B_chunks[i]),
                .cin    (carry[i]),
                .sum    (sum_blocks[i]),
                .cout   (),           // unused here; carry out is computed by carry-lookahead
                .P      (P_blocks[i]),
                .G      (G_blocks[i])
            );
        end
    endgenerate

    // Step 6: Compute carry signals between blocks using 8-bit block-level carry lookahead
    // Carry[i+1] = G_blocks[i] | (P_blocks[i] & Carry[i])
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : block_carry_logic
            assign carry[j+1] = G_blocks[j] | (P_blocks[j] & carry[j]);
        end
    endgenerate

    // Step 7: Assemble final 64-bit result from sum blocks
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : assemble_result
            assign result[8*idx +: 8] = sum_blocks[idx];
        end
    endgenerate

    // Step 8: Overflow detection based on signed subtraction rules:
    // Overflow if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 8-bit CLA Subtractor block for sum = A + B + cin, where B is already ~B
// Outputs internal propagate (P) and generate (G) for block-level carry lookahead
module cla_8bit_sub (
    input  wire [7:0] A,
    input  wire [7:0] B,     // this is ~B for subtraction, already complemented
    input  wire       cin,   // carry-in for the block
    output wire [7:0] sum,
    output wire       cout,  // carry-out from the block
    output wire       P,     // block propagate signal
    output wire       G      // block generate signal
);
    wire [7:0] P_bits; // per-bit propagate
    wire [7:0] G_bits; // per-bit generate
    wire [8:0] C;      // carry signals

    assign P_bits = A ^ B;
    assign G_bits = A & B;
    assign C[0] = cin;

    // Carry lookahead within 8 bits: C[i+1] = G[i] | (P[i] & C[i])
    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin : carry_internal
            assign C[k+1] = G_bits[k] | (P_bits[k] & C[k]);
        end
    endgenerate

    assign sum = P_bits ^ C[7:0];
    assign cout = C[8];

    // Block propagate: all bits propagate must be 1 for block propagate
    assign P = &P_bits;
    // Block generate: block generates a carry if it produces carry independently or via carry-in propagation
    assign G = G_bits[7] | (P_bits[7] & G_bits[6]) | (P_bits[7]&P_bits[6] & G_bits[5]) |
               (P_bits[7]&P_bits[6]&P_bits[5] & G_bits[4]) | (P_bits[7]&P_bits[6]&P_bits[5]&P_bits[4] & G_bits[3]) |
               (P_bits[7]&P_bits[6]&P_bits[5]&P_bits[4]&P_bits[3] & G_bits[2]) |
               (P_bits[7]&P_bits[6]&P_bits[5]&P_bits[4]&P_bits[3]&P_bits[2] & G_bits[1]) |
               (P_bits[7]&P_bits[6]&P_bits[5]&P_bits[4]&P_bits[3]&P_bits[2]&P_bits[1] & G_bits[0]);

endmodule