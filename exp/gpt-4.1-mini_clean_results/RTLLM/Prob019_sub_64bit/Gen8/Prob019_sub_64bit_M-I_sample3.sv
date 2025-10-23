module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Two's complement of B: ~B + 1 performed by adding A + (~B) + 1
    wire [63:0] B_neg;
    wire        carry_out;

    // Instantiate hierarchical 64-bit CLA subtractor: result = A + (~B) + 1
    cla_64bit_hier u_cla_64bit_hier (
        .A    (A),
        .B    (~B),
        .cin  (1'b1),
        .sum  (result),
        .cout (carry_out)
    );

    // Overflow detection for subtraction A - B:
    // Overflow if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// Hierarchical 64-bit Carry Lookahead Adder (8 blocks of 8-bit CLA + block CLA)
module cla_64bit_hier (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [7:0] block_p;   // Block propagate signals
    wire [7:0] block_g;   // Block generate signals
    wire [8:0] carry;     // Carry signals at block boundaries

    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : block_adders
            cla_8bit u_cla_8bit (
                .A    (A[8*i +: 8]),
                .B    (B[8*i +: 8]),
                .cin  (carry[i]),
                .sum  (sum[8*i +: 8]),
                .cout (/*unused*/),
                .p    (block_p[i]),
                .g    (block_g[i])
            );
        end
    endgenerate

    // Generate carry signals for each block using block propagate and generate
    // carry[i+1] = block_g[i] | (block_p[i] & carry[i])
    generate
        for (i = 0; i < 8; i = i + 1) begin : block_carry_gen
            assign carry[i+1] = block_g[i] | (block_p[i] & carry[i]);
        end
    endgenerate

    assign cout = carry[8];

endmodule


// 8-bit Carry Lookahead Adder Block with propagate and generate output
module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout,
    output wire       p, // block propagate
    output wire       g  // block generate
);
    wire [7:0] P; // propagate for each bit
    wire [7:0] G; // generate for each bit
    wire [8:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = cin;

    // Carry lookahead logic within 8-bit block
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[8] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign sum = P ^ C[7:0];
    assign cout = C[8];

    // Block propagate: all bits propagate
    assign p = &P;

    // Block generate: carry generated inside block without input carry
    assign g = G[7]
               | (P[7] & G[6])
               | (P[7] & P[6] & G[5])
               | (P[7] & P[6] & P[5] & G[4])
               | (P[7] & P[6] & P[5] & P[4] & G[3])
               | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2])
               | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1])
               | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);

endmodule