module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Segment inputs into 4 chunks of 16 bits each
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

    assign borrow[0] = 1'b1; // Initial carry-in for two's complement subtraction (A + ~B + 1)

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : sub_16bit_blocks
            sub_16bit_cla u_sub16 (
                .A      (A_seg[i]),
                .B      (B_seg[i]),
                .cin    (borrow[i]),
                .result (R_seg[i]),
                .cout   (borrow[i+1])
            );
        end
    endgenerate

    assign result = {R_seg[3], R_seg[2], R_seg[1], R_seg[0]};

    // Overflow detection:
    // Overflow occurs if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit CLA subtractor: computes result = A - B = A + (~B) + cin
// Fast carry lookahead using bitwise and group-level generate/propagate signals
module sub_16bit_cla (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,    // carry-in (borrow-in)
    output wire [15:0] result,
    output wire        cout    // carry-out (borrow-out)
);
    // Complement B once per 16-bit block for power saving
    wire [15:0] B_neg = ~B;

    // Bit-level propagate and generate
    wire [15:0] P = A ^ B_neg;  // propagate
    wire [15:0] G = A & B_neg;  // generate

    // Group propagate and generate signals (for 4 groups of 4 bits)
    wire [3:0] gp;  // group propagate
    wire [3:0] gg;  // group generate

    genvar gi;
    generate
        for (gi=0; gi<4; gi=gi+1) begin : group_pg
            assign gp[gi] = &P[gi*4 +: 4];                      // group propagate = AND of 4 bits
            assign gg[gi] = G[gi*4 +3] 
                          | (P[gi*4 +3] & G[gi*4 +2])
                          | (P[gi*4 +3] & P[gi*4 +2] & G[gi*4 +1])
                          | (P[gi*4 +3] & P[gi*4 +2] & P[gi*4 +1] & G[gi*4]);
        end
    endgenerate

    // Carry signals: 17 bits (carries into each bit and cout)
    wire [16:0] C;
    assign C[0] = cin;

    // Calculate carry into each 4-bit group (C[4], C[8], C[12], C[16])
    // Using group generate and propagate signals for fast lookahead:
    assign C[4]  = gg[0] | (gp[0] & C[0]);
    assign C[8]  = gg[1] | (gp[1] & C[4]);
    assign C[12] = gg[2] | (gp[2] & C[8]);
    assign C[16] = gg[3] | (gp[3] & C[12]);
    assign cout  = C[16];

    // Calculate carry into each bit inside groups
    // For each 4-bit group, compute carries C[1..4], C[5..8], C[9..12], C[13..16]
    genvar bi;
    generate
        for (gi=0; gi<4; gi=gi+1) begin : bit_carry_group
            // base carry in for group
            wire base_c = C[gi*4];

            // Bit-level carry inside the group
            assign C[gi*4 + 1] = G[gi*4] | (P[gi*4] & base_c);
            assign C[gi*4 + 2] = G[gi*4 + 1] | (P[gi*4 + 1] & G[gi*4]) | (P[gi*4 + 1] & P[gi*4] & base_c);
            assign C[gi*4 + 3] = G[gi*4 + 2] 
                              | (P[gi*4 + 2] & G[gi*4 + 1]) 
                              | (P[gi*4 + 2] & P[gi*4 + 1] & G[gi*4]) 
                              | (P[gi*4 + 2] & P[gi*4 + 1] & P[gi*4] & base_c);
            // C[gi*4 + 4] is carry out of the group, assigned above in group carry signals
        end
    endgenerate

    // Sum bits: result = P xor carry-in to each bit
    generate
        for (bi=0; bi<16; bi=bi+1) begin : sum_bits
            assign result[bi] = P[bi] ^ C[bi];
        end
    endgenerate

endmodule