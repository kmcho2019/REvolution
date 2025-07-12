module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] B_neg = ~B;
    wire        carry_out;

    // 64-bit subtraction via hierarchical CLA adder:
    // result = A + (~B) + 1
    cla_64bit u_cla_64bit (
        .A    (A),
        .B    (B_neg),
        .cin  (1'b1),
        .sum  (result),
        .cout (carry_out)
    );

    // Overflow detection:
    // Overflow occurs if sign of A differs from B and sign of result differs from A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit hierarchical CLA adder using 16 blocks of 4-bit CLA
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [64:0] carry; // carry[0] = cin
    assign carry[0] = cin;

    wire [15:0] block_p; // block propagate signals
    wire [15:0] block_g; // block generate signals

    genvar i;

    // Generate 16 blocks of 4-bit CLA
    generate
        for (i = 0; i < 16; i = i + 1) begin : cla_blocks
            wire [3:0] block_sum;
            wire       block_cout;

            // Each cla_4bit block gets carry-in from carry[i*4]
            cla_4bit cla4 (
                .A    (A[i*4 +: 4]),
                .B    (B[i*4 +: 4]),
                .cin  (carry[i]),
                .sum  (block_sum),
                .cout (block_cout),
                .p    (block_p[i]),
                .g    (block_g[i])
            );

            assign sum[i*4 +: 4] = block_sum;
            assign carry[i+1] = block_cout;
        end
    endgenerate

    // Carry lookahead for block carry-in signals (carry[1], carry[2], ..., carry[16])
    // carry[0] is cin (input carry)
    // Calculate carry[i] = block_g[i-1] | (block_p[i-1] & carry[i-1])

    // We'll recompute carry[1]..carry[16] based on block_p and block_g for better timing.
    // Re-assign carry[1..16] as this logic is redundant with carry assigned in generate above.
    // Instead, we keep the carry chain assigned in block generate for clear delay model.

    // Final cout = carry[16]
    assign cout = carry[16];

endmodule


// 4-bit CLA block with generate and propagate outputs
module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout,
    output wire       p, // block propagate
    output wire       g  // block generate
);
    wire [3:0] P; // bit propagate
    wire [3:0] G; // bit generate
    wire [4:0] C; // carry signals per bit (C[0] = cin)

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // Compute carries within 4-bit block using CLA equations
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0])
                  | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign sum = P ^ C[3:0];
    assign cout = C[4];

    // Block propagate = AND of all bit propagates
    assign p = &P;

    // Block generate = G3 + (P3 * G2) + (P3*P2*G1) + (P3*P2*P1*G0)
    assign g = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule