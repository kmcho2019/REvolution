module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Two's complement subtraction: A - B = A + (~B + 1)
    wire [63:0] B_comp = ~B;

    wire [63:0] sum;
    wire        cout;

    // Perform 64-bit addition A + B_comp + 1 using hierarchical CLA
    cla_64bit_sub u_cla64 (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),
        .sum (sum),
        .cout(cout)
    );

    assign result = sum;

    // Overflow detection:
    // overflow occurs if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// Top-level 64-bit CLA subtractor using four 16-bit CLA blocks and block carry lookahead
module cla_64bit_sub (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    // Break inputs into 4 segments of 16 bits
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] sum_seg [3:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    // Propagate and generate signals for each 16-bit block
    wire [3:0] P_blk;
    wire [3:0] G_blk;

    // Carry signals between blocks
    wire [4:0] C_blk;
    assign C_blk[0] = cin;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : gen_16bit_blocks
            cla_16bit u_cla16 (
                .A       (A_seg[i]),
                .B       (B_seg[i]),
                .cin     (C_blk[i]),
                .sum     (sum_seg[i]),
                .cout    (),
                .P       (P_blk[i]),
                .G       (G_blk[i])
            );
        end
    endgenerate

    // Hierarchical carry lookahead for block-level carry-in signals
    // C_blk[i+1] = G_blk[i] | (P_blk[i] & C_blk[i])
    generate
        for (i=0; i<3; i=i+1) begin : gen_block_carry
            assign C_blk[i+1] = G_blk[i] | (P_blk[i] & C_blk[i]);
        end
    endgenerate
    // Final carry-out
    assign cout = G_blk[3] | (P_blk[3] & C_blk[3]);

    // Assemble final 64-bit sum
    assign sum = {sum_seg[3], sum_seg[2], sum_seg[1], sum_seg[0]};
endmodule


// 16-bit CLA block with propagate/generate outputs
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout,
    output wire        P, // block propagate
    output wire        G  // block generate
);
    wire [15:0] P_i; // per-bit propagate
    wire [15:0] G_i; // per-bit generate
    wire [16:0] C;   // carry signals

    assign P_i = A ^ B;
    assign G_i = A & B;
    assign C[0] = cin;

    // Generate carries using carry lookahead within 16 bits
    genvar j;
    generate
        for (j=0; j<16; j=j+1) begin : carry_gen_16
            assign C[j+1] = G_i[j] | (P_i[j] & C[j]);
        end
    endgenerate

    assign sum = P_i ^ C[15:0];
    assign cout = C[16];

    // Block propagate is AND of all bit propagates
    assign P = &P_i;

    // Block generate is true if the block generates carry regardless of carry-in:
    // G = G[15] + P[15]*G[14] + P[15]*P[14]*G[13] + ... + P[15:1]*G[0]
    // This can be computed efficiently using recursive or parallel prefix, but here use recursive logic:
    // To simplify, use a parallel prefix style with intermediate signals.

    // We'll compute block generate by recursive approach:

    // Intermediate generate signals:
    wire [15:0] g_mux;

    // g_mux[0] = G_i[0]
    assign g_mux[0] = G_i[0];
    // g_mux[j] = G_i[j] | (P_i[j] & g_mux[j-1])
    genvar k;
    generate
        for (k=1; k<16; k=k+1) begin : gen_g_mux
            assign g_mux[k] = G_i[k] | (P_i[k] & g_mux[k-1]);
        end
    endgenerate

    assign G = g_mux[15];

endmodule