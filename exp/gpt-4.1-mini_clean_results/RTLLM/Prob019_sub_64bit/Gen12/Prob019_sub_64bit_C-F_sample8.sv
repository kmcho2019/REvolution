module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Break inputs into 4 segments of 16 bits each
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] R_seg [3:0];
    wire        borrow [4:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    assign borrow[0] = 1'b1;  // initial carry-in = 1 for two's complement subtraction (A + ~B + 1)

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : sub_16bit_blocks
            sub_16bit_cla #(.WIDTH(16)) u_sub16 (
                .A      (A_seg[i]),
                .B      (B_seg[i]),
                .cin    (borrow[i]),
                .result (R_seg[i]),
                .cout   (borrow[i+1])
            );
        end
    endgenerate

    assign result = {R_seg[3], R_seg[2], R_seg[1], R_seg[0]};

    // Overflow detection for subtraction:
    // Overflow if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit subtractor composed of two 8-bit CLA subtractors chained internally with carry/borrow
module sub_16bit_cla #(
    parameter WIDTH = 16
) (
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire             cin,     // carry-in (borrow-in) for 16-bit subtractor
    output wire [WIDTH-1:0] result,
    output wire             cout     // carry-out (borrow-out) from 16-bit subtractor
);

    // Invert B once per 16-bit block to reduce switching and share complemented B internally
    wire [WIDTH-1:0] B_comp = ~B;

    wire carry_mid;  // internal carry between lower 8-bit and upper 8-bit CLA blocks

    // Lower 8 bits CLA subtractor
    cla_8bit_sub u_cla_low (
        .A    (A[7:0]),
        .B    (B_comp[7:0]),
        .cin  (cin),
        .sum  (result[7:0]),
        .cout (carry_mid)
    );

    // Upper 8 bits CLA subtractor
    cla_8bit_sub u_cla_high (
        .A    (A[15:8]),
        .B    (B_comp[15:8]),
        .cin  (carry_mid),
        .sum  (result[15:8]),
        .cout (cout)
    );

endmodule


// 8-bit CLA subtractor implementing sum = A + B + cin with carry-lookahead logic optimized
// Inputs B here are complemented (~B) already
module cla_8bit_sub (
    input  wire [7:0] A,
    input  wire [7:0] B,     // B already complemented (~B)
    input  wire       cin,   // carry-in for subtractor (borrow-in)
    output wire [7:0] sum,
    output wire       cout   // carry-out (borrow-out)
);

    // Propagate and generate signals for each bit
    wire [7:0] P;   // propagate: P = A ^ B
    wire [7:0] G;   // generate:  G = A & B

    assign P = A ^ B;
    assign G = A & B;

    // Carry signals, C[0] = cin, C[8] = cout
    wire [8:0] C;

    assign C[0] = cin;

    // Implement carry-lookahead logic to reduce carry chain delay:
    // Calculate group propagate and generate signals in pairs to speed carry generation
    // Using Brent-Kung-like parallel prefix approach for 8 bits.

    // Level 1: combine bit pairs (0+1), (2+3), (4+5), (6+7)
    wire [3:0] G1, P1;
    genvar i;

    generate
        for (i = 0; i < 4; i = i + 1) begin : level1
            assign G1[i] = G[2*i+1] | (P[2*i+1] & G[2*i]);
            assign P1[i] = P[2*i+1] & P[2*i];
        end
    endgenerate

    // Level 2: combine pairs from Level 1 (0+1), (2+3)
    wire [1:0] G2, P2;
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign P2[0] = P1[1] & P1[0];
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign P2[1] = P1[3] & P1[2];

    // Level 3: combine pairs from Level 2 (0+1)
    wire G3, P3;
    assign G3 = G2[1] | (P2[1] & G2[0]);
    assign P3 = P2[1] & P2[0];

    // Compute carries:
    // C[1] = G[0] | (P[0] & C[0])
    assign C[1] = G[0] | (P[0] & C[0]);

    // C[2] = G1[0] | (P1[0] & C[0])
    assign C[2] = G1[0] | (P1[0] & C[0]);

    // C[3] = G[2] | (P[2] & C[2])
    assign C[3] = G[2] | (P[2] & C[2]);

    // C[4] = G2[0] | (P2[0] & C[0])
    assign C[4] = G2[0] | (P2[0] & C[0]);

    // C[5] = G[4] | (P[4] & C[4])
    assign C[5] = G[4] | (P[4] & C[4]);

    // C[6] = G1[2] | (P1[2] & C[4])
    assign C[6] = G1[2] | (P1[2] & C[4]);

    // C[7] = G[6] | (P[6] & C[6])
    assign C[7] = G[6] | (P[6] & C[6]);

    // C[8] = G3 | (P3 & C[0])  (final carry-out)
    assign C[8] = G3 | (P3 & C[0]);

    // Sum bits: sum = P ^ C[i]
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_gen
            assign sum[i] = P[i] ^ C[i];
        end
    endgenerate

    assign cout = C[8];

endmodule