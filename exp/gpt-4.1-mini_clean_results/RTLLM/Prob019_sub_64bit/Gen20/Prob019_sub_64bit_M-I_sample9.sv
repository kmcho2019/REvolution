module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Decompose 64-bit inputs into 16 x 4-bit blocks
    // We'll compute each 4-bit subtractor sum and carry signals
    wire [15:0] P_block;   // propagate per 4-bit block
    wire [15:0] G_block;   // generate per 4-bit block
    wire [16:0] C_block;   // carry-in per block, C_block[0] = initial carry-in (=1 for two's complement subtraction)

    assign C_block[0] = 1'b1; // initial carry-in for subtraction (A + ~B + 1)

    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : gen_4bit_sub
            // 4-bit CLA subtractor block for A[i*4 +:4] - B[i*4 +:4]
            cla_4bit_sub u4sub (
                .A      (A[i*4 +:4]),
                .B      (B[i*4 +:4]),
                .cin    (C_block[i]),
                .sum    (result[i*4 +:4]),
                .P      (P_block[i]),
                .G      (G_block[i])
            );
        end
    endgenerate

    // Compute all carry signals at block level from P_block and G_block with carry-lookahead logic
    // Carry for block i+1: C_block[i+1] = G_block[i] | (P_block[i] & C_block[i])
    // Implemented as a 16-bit carry-lookahead using parallel prefix logic for speed

    // We implement a parallel prefix carry generator for 16 blocks:
    // We'll use a simple Kogge-Stone style approach for the 16-bit block carry signals.

    // Step 1: Generate initial (G,P) pairs
    wire [15:0] G_level [4:0]; // store generate at each level (depth 0..4)
    wire [15:0] P_level [4:0]; // store propagate at each level (depth 0..4)

    assign G_level[0] = G_block;
    assign P_level[0] = P_block;

    // Compute carry lookahead in log2(16)=4 stages
    genvar lvl, idx;
    generate
        for (lvl=1; lvl<=4; lvl=lvl+1) begin : prefix_levels
            for (idx=0; idx<16; idx=idx+1) begin : prefix_nodes
                if (idx < (1 << (lvl-1))) begin
                    // For the first 1<<(lvl-1) blocks, no new computation needed (copy previous)
                    assign G_level[lvl][idx] = G_level[lvl-1][idx];
                    assign P_level[lvl][idx] = P_level[lvl-1][idx];
                end else begin
                    // Combine pairs (idx and idx - 2^(lvl-1))
                    wire g1 = G_level[lvl-1][idx];
                    wire p1 = P_level[lvl-1][idx];
                    wire g0 = G_level[lvl-1][idx - (1 << (lvl-1))];
                    wire p0 = P_level[lvl-1][idx - (1 << (lvl-1))];
                    assign G_level[lvl][idx] = g1 | (p1 & g0);
                    assign P_level[lvl][idx] = p1 & p0;
                end
            end
        end
    endgenerate

    // Compute carry signals for each block:
    // C_block[0] = initial carry in = 1
    // C_block[i+1] = G_level[4][i] | (P_level[4][i] & C_block[0])

    // Create a loop to compute C_block[1..16]
    generate
        for (i=0; i<16; i=i+1) begin : carry_assign
            assign C_block[i+1] = G_level[4][i] | (P_level[4][i] & C_block[0]);
        end
    endgenerate

    // Overflow detection:
    // overflow = (A[63] != B[63]) && (result[63] != A[63])
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 4-bit CLA subtractor block performing: sum = A + (~B) + cin
// Outputs block propagate and generate signals for carry-lookahead
module cla_4bit_sub (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       cin, // carry-in for this block (borrow_in)
    output wire [3:0] sum,
    output wire       P,   // block propagate
    output wire       G    // block generate
);
    wire [3:0] B_neg = ~B; // bitwise complement of B

    wire [3:0] p; // propagate signals for bits
    wire [3:0] g; // generate signals for bits
    wire [4:0] c; // carry signals for bits

    assign c[0] = cin;

    // Compute bit-level propagate and generate
    assign p = A ^ B_neg;
    assign g = A & B_neg;

    // Carry lookahead for 4 bits
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum = p ^ c[3:0];

    // Block propagate and generate signals
    assign P = &p;         // P = p3 & p2 & p1 & p0
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule