module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Precompute complemented B once for all blocks
    wire [63:0] B_neg = ~B;

    // Break inputs into 4 segments of 16 bits each
    wire [15:0] A_seg [3:0];
    wire [15:0] B_neg_seg [3:0];
    wire [15:0] R_seg [3:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_neg_seg[0] = B_neg[15:0];
    assign B_neg_seg[1] = B_neg[31:16];
    assign B_neg_seg[2] = B_neg[47:32];
    assign B_neg_seg[3] = B_neg[63:48];

    // Internal carry signals between 16-bit blocks
    wire [4:0] c; // carry signals: c[0] is initial carry-in, c[4] is final carry-out
    assign c[0] = 1'b1;  // for subtraction: adding 1 for two's complement (~B+1)

    // Internal propagate and generate signals per 16-bit block
    wire [3:0] P_block;
    wire [3:0] G_block;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : sub_16bit_blocks
            cla_16bit_sub u_sub16 (
                .A      (A_seg[i]),
                .B_neg  (B_neg_seg[i]), // already complemented B segment
                .cin    (c[i]),
                .sum    (R_seg[i]),
                .P      (P_block[i]),
                .G      (G_block[i]),
                .cout   (/* unused: c[i+1] computed by top CLA logic */)
            );
        end
    endgenerate

    // Top-level 4-block CLA carry lookahead for the 16-bit blocks
    cla_4block u_cla_4block (
        .P      (P_block),
        .G      (G_block),
        .cin    (c[0]),
        .cout   (c[4:1])
    );

    // Assign carry outputs from top-level CLA to internal block carries
    // Connect each block carry-in (except initial c[0]) to c[1..3]
    // Actually, c[1], c[2], c[3] are carry-ins for blocks 1,2,3 respectively
    // This connection was implicit in the loop before; now done explicitly:
    // Pass updated carry-ins to blocks via generate loop

    // But the blocks instantiated above use c[i] directly as cin.
    // We must override their carry-in to match calculated carry-ins from cla_4block.
    // So we need a workaround: instantiate blocks again with carries assigned after carry-lookahead.

    // To fix this, we instantiate blocks in two phases: first to get P and G only,
    // then after carry computation, do addition with correct carries.
    // But Verilog doesn't allow this style easily; so instead:

    // We create two modules: one to generate P and G from inputs only,
    // second to do final addition given cin.

    // To keep simple, instantiate the 16-bit CLA blocks twice:
    // First: P and G generation with zero cin (carry in irrelevant for P and G)
    // Second: sum calculation with correct cin after carry chain is resolved.

    // Redefine sub_16bit_blocks into two modules: pg_gen and add_with_cin.

    // So we redesign accordingly below:

endmodule


// 16-bit Propagate/Generate Generator (no addition), only generate P and G signals for block carry-lookahead
module pg_gen_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B_neg,
    output wire        P,
    output wire        G
);
    wire [15:0] P_bits = A ^ B_neg; // propagate bits
    wire [15:0] G_bits = A & B_neg; // generate bits

    // Block propagate is AND of all propagate bits (all bits must propagate carry)
    assign P = &P_bits;

    // Block generate is:
    // G = G15 | (P15 & G14) | (P15 & P14 & G13) | ... (carry-lookahead generate)
    // We'll implement carry-lookahead generate for 16 bits

    // Implement parallel prefix carry generate (Kogge-Stone style)

    wire [15:0] g_level [4:0]; // 5 levels: level 0 original G, level 4 final

    assign g_level[0] = G_bits;
    wire [15:0] p_level [4:0];
    assign p_level[0] = P_bits;

    genvar i,j;
    generate
        for (j=1; j<=4; j=j+1) begin : level_loop
            for (i=0; i<16; i=i+1) begin : bit_loop
                if (i >= 2**(j-1)) begin
                    assign g_level[j][i] = g_level[j-1][i] | (p_level[j-1][i] & g_level[j-1][i - 2**(j-1)]);
                    assign p_level[j][i] = p_level[j-1][i] & p_level[j-1][i - 2**(j-1)];
                end else begin
                    assign g_level[j][i] = g_level[j-1][i];
                    assign p_level[j][i] = p_level[j-1][i];
                end
            end
        end
    endgenerate

    assign G = g_level[4][15];

endmodule


// 16-bit CLA subtractor: inputs A, B_neg, cin; outputs sum, block propagate and generate
module cla_16bit_sub (
    input  wire [15:0] A,
    input  wire [15:0] B_neg,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        P,
    output wire        G,
    output wire        cout
);

    wire [15:0] P_bits = A ^ B_neg;
    wire [15:0] G_bits = A & B_neg;

    wire [16:0] c;
    assign c[0] = cin;

    // Carry computation using Kogge-Stone-like parallel prefix logic for speed
    // Level 0 signals
    wire [15:0] g_level0 = G_bits;
    wire [15:0] p_level0 = P_bits;

    wire [15:0] g_level [4:0];
    wire [15:0] p_level [4:0];

    assign g_level[0] = g_level0;
    assign p_level[0] = p_level0;

    genvar j,i;
    generate
        for (j=1; j<=4; j=j+1) begin : level_loop
            for (i=0; i<16; i=i+1) begin : bit_loop
                if (i >= 2**(j-1)) begin
                    assign g_level[j][i] = g_level[j-1][i] | (p_level[j-1][i] & g_level[j-1][i - 2**(j-1)]);
                    assign p_level[j][i] = p_level[j-1][i] & p_level[j-1][i - 2**(j-1)];
                end else begin
                    assign g_level[j][i] = g_level[j-1][i];
                    assign p_level[j][i] = p_level[j-1][i];
                end
            end
        end
    endgenerate

    // Carry out of bit i is g_level[4][i-1] | (p_level[4][i-1] & c[0]) for i >=1
    assign c[1]  = g_level[4][0]  | (p_level[4][0]  & c[0]);
    assign c[2]  = g_level[4][1]  | (p_level[4][1]  & c[0]);
    assign c[3]  = g_level[4][2]  | (p_level[4][2]  & c[0]);
    assign c[4]  = g_level[4][3]  | (p_level[4][3]  & c[0]);
    assign c[5]  = g_level[4][4]  | (p_level[4][4]  & c[0]);
    assign c[6]  = g_level[4][5]  | (p_level[4][5]  & c[0]);
    assign c[7]  = g_level[4][6]  | (p_level[4][6]  & c[0]);
    assign c[8]  = g_level[4][7]  | (p_level[4][7]  & c[0]);
    assign c[9]  = g_level[4][8]  | (p_level[4][8]  & c[0]);
    assign c[10] = g_level[4][9]  | (p_level[4][9]  & c[0]);
    assign c[11] = g_level[4][10] | (p_level[4][10] & c[0]);
    assign c[12] = g_level[4][11] | (p_level[4][11] & c[0]);
    assign c[13] = g_level[4][12] | (p_level[4][12] & c[0]);
    assign c[14] = g_level[4][13] | (p_level[4][13] & c[0]);
    assign c[15] = g_level[4][14] | (p_level[4][14] & c[0]);
    assign c[16] = g_level[4][15] | (p_level[4][15] & c[0]);

    assign sum = P_bits ^ c[15:0];
    assign cout = c[16];

    // Block propagate and generate signals for top-level carry lookahead
    assign P = &P_bits;
    assign G = g_level[4][15];

endmodule


// 4-block CLA carry lookahead generator for chaining four 16-bit blocks
module cla_4block (
    input  wire [3:0] P,  // block propagate signals
    input  wire [3:0] G,  // block generate signals
    input  wire       cin,
    output wire [3:1] cout // carry outs for blocks 1 to 3 (cout[3:1])
);
    // Carry lookahead logic for 4 blocks:
    // c[1] = G[0] + P[0]*cin
    // c[2] = G[1] + P[1]*G[0] + P[1]*P[0]*cin
    // c[3] = G[2] + P[2]*G[1] + P[2]*P[1]*G[0] + P[2]*P[1]*P[0]*cin
    // final carry out (for completeness) is not needed here

    assign cout[1] = G[0] | (P[0] & cin);
    assign cout[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign cout[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);

endmodule


// Top-level module instantiation and wiring for final summation and overflow detection:

module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement B once
    wire [63:0] B_neg = ~B;

    // Break inputs into 4 16-bit segments
    wire [15:0] A_seg [3:0];
    wire [15:0] B_neg_seg [3:0];
    wire [15:0] R_seg [3:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_neg_seg[0] = B_neg[15:0];
    assign B_neg_seg[1] = B_neg[31:16];
    assign B_neg_seg[2] = B_neg[47:32];
    assign B_neg_seg[3] = B_neg[63:48];

    // Intermediate signals for carry-lookahead
    wire [3:0] P_block;
    wire [3:0] G_block;
    wire [4:0] c;
    assign c[0] = 1'b1; // carry in for two's complement subtraction

    // First generate P and G for each block
    wire [15:0] temp_sum [3:0];
    wire [3:0] dummy_cout; // unused here

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : pg_generation
            pg_gen_16bit u_pggen (
                .A(A_seg[i]),
                .B_neg(B_neg_seg[i]),
                .P(P_block[i]),
                .G(G_block[i])
            );
        end
    endgenerate

    // Compute carry ins for blocks 1..3 using 4-block CLA
    wire [3:1] block_carry;
    cla_4block u_cla4 (
        .P(P_block),
        .G(G_block),
        .cin(c[0]),
        .cout(block_carry)
    );

    assign c[1] = block_carry[1];
    assign c[2] = block_carry[2];
    assign c[3] = block_carry[3];

    // Compute sums using correct carry ins
    generate
        for (i=0; i<4; i=i+1) begin : sum_generation
            cla_16bit_sub u_sub16 (
                .A     (A_seg[i]),
                .B_neg (B_neg_seg[i]),
                .cin   (c[i]),
                .sum   (R_seg[i]),
                .P     (),    // unused here
                .G     (),    // unused here
                .cout  ()     // unused here
            );
        end
    endgenerate

    assign result = {R_seg[3], R_seg[2], R_seg[1], R_seg[0]};

    // Overflow detection: (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule