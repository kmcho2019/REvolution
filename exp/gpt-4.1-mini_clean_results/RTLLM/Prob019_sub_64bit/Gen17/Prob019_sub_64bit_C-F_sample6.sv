module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement B once for full 64-bit width
    wire [63:0] B_comp = ~B;

    // Lower and upper 32-bit segments of A and B_comp
    wire [31:0] A_lower = A[31:0];
    wire [31:0] A_upper = A[63:32];
    wire [31:0] B_comp_lower = B_comp[31:0];
    wire [31:0] B_comp_upper = B_comp[63:32];

    // Wires for lower and upper results and carry outs
    wire [31:0] res_lower;
    wire [31:0] res_upper;
    wire        carry_lower;
    wire        carry_upper;

    // Lower 32-bit CLA: A_lower + ~B_lower + 1
    cla_32bit_hier cla_lower (
        .A   (A_lower),
        .B   (B_comp_lower),
        .cin (1'b1),       // +1 for two's complement subtraction
        .sum (res_lower),
        .cout(carry_lower)
    );

    // Upper 32-bit CLA: A_upper + ~B_upper + carry from lower
    cla_32bit_hier cla_upper (
        .A   (A_upper),
        .B   (B_comp_upper),
        .cin (carry_lower),
        .sum (res_upper),
        .cout(carry_upper)
    );

    // Concatenate results for full 64-bit difference
    assign result = {res_upper, res_lower};

    // Overflow detection:
    // Overflow occurs if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// Hierarchical 32-bit Carry Lookahead Adder
// 32-bit adder with 8-bit sub-block carry-lookahead units
module cla_32bit_hier (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);
    wire [31:0] P; // propagate
    wire [31:0] G; // generate
    wire [4:0]  C; // carries between 8-bit blocks (C[0] = cin)

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // 8-bit block propagate and generate signals
    wire [3:0] block_P;
    wire [3:0] block_G;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_pg
            // block propagate = AND of all propagates in 8-bit block
            assign block_P[i] = &P[i*8 +: 8];
            // block generate = 
            // G7 + P7*G6 + P7*P6*G5 + ... + P7*...*P1*G0
            // Implemented via carry lookahead inside block (see cla_8bit)
            // Here we instantiate cla_8bit PG outputs instead of recalculating
        end
    endgenerate
endmodule

// 8-bit Carry Lookahead Adder block to compute sum, cout, block_G, block_P
module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout,
    output wire       block_G, // Block generate
    output wire       block_P  // Block propagate
);
    wire [7:0] P = A ^ B;
    wire [7:0] G = A & B;
    wire [8:0] C;

    assign C[0] = cin;

    // Generate carry signals with hierarchical CLA logic
    // Carry equation: C[i+1] = G[i] | (P[i] & C[i])
    // Implement full 8-bit carry chain

    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);

    assign sum = P ^ C[7:0];
    assign cout = C[8];

    // Block propagate is AND of all P bits
    assign block_P = &P;

    // Block generate: G7 + P7*G6 + P7*P6*G5 + ... + P7*...*P1*G0
    // Computed using carry lookahead logic for 8 bits:
    wire g0 = G[0];
    wire g1 = G[1];
    wire g2 = G[2];
    wire g3 = G[3];
    wire g4 = G[4];
    wire g5 = G[5];
    wire g6 = G[6];
    wire g7 = G[7];

    wire p0 = P[0];
    wire p1 = P[1];
    wire p2 = P[2];
    wire p3 = P[3];
    wire p4 = P[4];
    wire p5 = P[5];
    wire p6 = P[6];
    wire p7 = P[7];

    assign block_G = g7
                     | (p7 & g6)
                     | (p7 & p6 & g5)
                     | (p7 & p6 & p5 & g4)
                     | (p7 & p6 & p5 & p4 & g3)
                     | (p7 & p6 & p5 & p4 & p3 & g2)
                     | (p7 & p6 & p5 & p4 & p3 & p2 & g1)
                     | (p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0);

endmodule


// Full implementation of the hierarchical 32-bit CLA using four 8-bit CLAs
module cla_32bit_hier (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);
    wire [3:0] block_cin;
    wire [3:0] block_cout;
    wire [3:0] block_P;
    wire [3:0] block_G;
    wire [31:0] block_sum;

    assign block_cin[0] = cin;

    // Instantiate 4 blocks of 8-bit CLA
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_blocks
            cla_8bit cla_block (
                .A        (A[i*8 +: 8]),
                .B        (B[i*8 +: 8]),
                .cin      (block_cin[i]),
                .sum      (block_sum[i*8 +: 8]),
                .cout     (block_cout[i]),
                .block_G  (block_G[i]),
                .block_P  (block_P[i])
            );
        end
    endgenerate

    // Calculate carries into each 8-bit block (except the first)
    // Using block generate and propagate signals and initial cin

    // C[1] = G0 + P0*C0
    assign block_cin[1] = block_G[0] | (block_P[0] & block_cin[0]);
    // C[2] = G1 + P1*G0 + P1*P0*C0
    assign block_cin[2] = block_G[1] | (block_P[1] & block_G[0]) | (block_P[1] & block_P[0] & block_cin[0]);
    // C[3] = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*C0
    assign block_cin[3] = block_G[2]
                          | (block_P[2] & block_G[1])
                          | (block_P[2] & block_P[1] & block_G[0])
                          | (block_P[2] & block_P[1] & block_P[0] & block_cin[0]);

    // Final carry out:
    // Cout = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*C0
    assign cout = block_G[3]
                  | (block_P[3] & block_G[2])
                  | (block_P[3] & block_P[2] & block_G[1])
                  | (block_P[3] & block_P[2] & block_P[1] & block_G[0])
                  | (block_P[3] & block_P[2] & block_P[1] & block_P[0] & block_cin[0]);

    assign sum = block_sum;

endmodule