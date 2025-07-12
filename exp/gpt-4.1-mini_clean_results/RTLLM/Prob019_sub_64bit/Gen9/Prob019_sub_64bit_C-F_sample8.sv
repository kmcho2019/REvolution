module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Split into four 16-bit segments
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

    assign borrow[0] = 1'b1; // cin=1 for two's complement subtraction (A + ~B + 1)

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : sub16_blocks
            sub_16bit_cla_opt u_sub16 (
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
    // Overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire R_sign = result[63];
    assign overflow = (A_sign != B_sign) && (R_sign != A_sign);

endmodule


// 16-bit subtractor composed of two optimized 8-bit CLA subtractors chained by borrow
module sub_16bit_cla_opt (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,   // initial borrow in
    output wire [15:0] result,
    output wire        cout   // borrow out
);
    wire borrow_mid;

    // Lower 8 bits subtractor
    cla_8bit_sub_opt cla_low (
        .A    (A[7:0]),
        .B    (B[7:0]),
        .cin  (cin),
        .sum  (result[7:0]),
        .cout (borrow_mid)
    );

    // Upper 8 bits subtractor
    cla_8bit_sub_opt cla_high (
        .A    (A[15:8]),
        .B    (B[15:8]),
        .cin  (borrow_mid),
        .sum  (result[15:8]),
        .cout (cout)
    );
endmodule


// Optimized 8-bit CLA subtractor with carry-lookahead:
// Computes sum = A + (~B) + cin using lookahead logic with group P/G and prefix carry calculation
module cla_8bit_sub_opt (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    // B negated once here (shared for all bits)
    wire [7:0] B_neg = ~B;

    // Bitwise propagate and generate
    wire [7:0] P = A ^ B_neg;   // propagate = A xor B'
    wire [7:0] G = A & B_neg;   // generate  = A and B'

    // Carry signals C[0] to C[8]
    wire [8:0] C;

    assign C[0] = cin;

    // Group propagate and generate for carry lookahead
    wire P0_1, G0_1;
    wire P2_3, G2_3;
    wire P4_5, G4_5;
    wire P6_7, G6_7;

    // 2-bit groups
    assign P0_1 = P[1] & P[0];
    assign G0_1 = G[1] | (P[1] & G[0]);

    assign P2_3 = P[3] & P[2];
    assign G2_3 = G[3] | (P[3] & G[2]);

    assign P4_5 = P[5] & P[4];
    assign G4_5 = G[5] | (P[5] & G[4]);

    assign P6_7 = P[7] & P[6];
    assign G6_7 = G[7] | (P[7] & G[6]);

    // 4-bit groups
    wire P0_3, G0_3;
    wire P4_7, G4_7;

    assign P0_3 = P2_3 & P0_1;
    assign G0_3 = G2_3 | (P2_3 & G0_1);

    assign P4_7 = P6_7 & P4_5;
    assign G4_7 = G6_7 | (P6_7 & G4_5);

    // Carry lookahead:
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G0_1 | (P0_1 & C[0]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G0_3 | (P0_3 & C[0]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G4_5 | (P4_5 & C[4]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G4_7 | (P4_7 & C[0]); // final carry out

    assign sum = P ^ C[7:0];   // sum = propagate xor carry-in
    assign cout = C[8];
endmodule