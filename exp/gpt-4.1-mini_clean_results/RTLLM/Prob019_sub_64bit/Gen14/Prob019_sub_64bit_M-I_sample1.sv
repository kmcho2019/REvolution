module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Subtraction implemented as A + (~B) + 1, i.e. two's complement subtraction using a 64-bit CLA

    wire [63:0] B_neg = ~B;
    wire cout;

    cla_64bit u_cla64 (
        .A   (A),
        .B   (B_neg),
        .cin (1'b1),   // +1 for two's complement subtraction
        .sum (result),
        .cout(cout)
    );

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Carry Lookahead Adder
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [63:0] P; // propagate signals
    wire [63:0] G; // generate signals
    wire [64:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = cin;

    // To handle the large carry chain efficiently, we implement hierarchical carry lookahead:
    // Divide into 4 groups of 16 bits, compute group propagate/generate, then compute carries between groups.

    // Group propagate and generate signals for each 16-bit block
    wire [3:0] PG; // group propagate
    wire [3:0] GG; // group generate

    genvar i, j;

    // Per bit carry computation inside each 16-bit group
    // We'll build carry signals inside each 16-bit chunk and then connect them hierarchically.

    // Carry signals inside groups (each 16 bits)
    wire [16:0] C_16 [3:0]; // 17 carry signals per group

    // Generate PG and GG for each group using carry lookahead
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_block
            // Indices for this group's bits
            localparam int start_bit = i*16;

            // Calculate carry signals inside this group
            assign C_16[i][0] = 1'b0; // temporary, will fix below

            for (j = 0; j < 16; j = j +1) begin : bit_carry
                assign C_16[i][j+1] = G[start_bit + j] | (P[start_bit + j] & C_16[i][j]);
            end

            // Compute group propagate: PG = AND of propagates in group
            wire [15:0] p_group = P[start_bit +:16];
            assign PG[i] = &p_group;

            // Compute group generate: GG = G15 + P15*G14 + P15*P14*G13 + ... + P15*...*P0*Cin
            // Equivalent to last carry out of the group with C_16[i][0] = 0
            assign GG[i] = C_16[i][16];

        end
    endgenerate

    // Now compute actual carries into each group:
    // C[0] = cin (external)
    // C_group[0] = C[0]
    // C_group[1] = GG[0] | (PG[0] & C_group[0])
    // C_group[2] = GG[1] | (PG[1] & C_group[1])
    // C_group[3] = GG[2] | (PG[2] & C_group[2])
    // C_group[4] = GG[3] | (PG[3] & C_group[3]) = cout

    wire [4:0] C_group;
    assign C_group[0] = cin;

    assign C_group[1] = GG[0] | (PG[0] & C_group[0]);
    assign C_group[2] = GG[1] | (PG[1] & C_group[1]);
    assign C_group[3] = GG[2] | (PG[2] & C_group[2]);
    assign C_group[4] = GG[3] | (PG[3] & C_group[3]);
    assign cout = C_group[4];

    // Now update the first carry inside each group using the actual carry-in for the group:
    // Recompute the C_16 carry signals for each group with correct carry-in = C_group[i]
    // For simplicity and better readability, we implement full carry chain for each bit with known group carry-in.

    wire [16:0] carry_in_group [3:0];
    wire [63:0] carry_internal;

    generate
        for (i = 0; i < 4; i = i + 1) begin : update_carries
            localparam int start_bit = i*16;
            assign carry_in_group[i][0] = C_group[i];

            for (j = 0; j < 16; j = j + 1) begin : bit_carry_update
                assign carry_in_group[i][j+1] = G[start_bit + j] | (P[start_bit + j] & carry_in_group[i][j]);
                assign carry_internal[start_bit + j] = carry_in_group[i][j];
            end
        end
    endgenerate

    // sum = P ^ carry_in (carry_in per bit)
    assign sum = P ^ carry_internal;

endmodule