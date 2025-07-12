module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Precompute bitwise complement of B once
    wire [63:0] B_comp = ~B;

    // Split operands and complemented B into lower and upper 32-bit halves
    wire [31:0] A_lower = A[31:0];
    wire [31:0] A_upper = A[63:32];
    wire [31:0] B_lower = B_comp[31:0];
    wire [31:0] B_upper = B_comp[63:32];

    // Carry out from lower 32-bit CLA to upper 32-bit CLA
    wire carry_lower;
    wire carry_upper;

    wire [31:0] res_lower;
    wire [31:0] res_upper;

    // Lower 32-bit CLA: sum = A_lower + ~B_lower + 1 (carry_in = 1)
    cla_32bit_lookahead cla_lower (
        .A   (A_lower),
        .B   (B_lower),
        .cin (1'b1),
        .sum (res_lower),
        .cout(carry_lower)
    );

    // Upper 32-bit CLA: sum = A_upper + ~B_upper + carry from lower
    cla_32bit_lookahead cla_upper (
        .A   (A_upper),
        .B   (B_upper),
        .cin (carry_lower),
        .sum (res_upper),
        .cout(carry_upper)
    );

    assign result = {res_upper, res_lower};

    // Overflow detection:
    // overflow = (sign(A) != sign(B)) && (sign(result) != sign(A))
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 32-bit Carry Lookahead Adder with hierarchical group generate/propagate logic
// Implements sum = A + B + cin, suitable for two's complement subtraction (B = ~B + 1 externally)
module cla_32bit_lookahead (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);

    wire [31:0] P; // propagate
    wire [31:0] G; // generate
    wire [7:0]  P_group; // group propagate for each 4-bit block
    wire [7:0]  G_group; // group generate for each 4-bit block
    wire [8:0]  C_group; // carry for each 4-bit block, C_group[0] = cin

    // Calculate bit propagate and generate signals
    assign P = A ^ B;
    assign G = A & B;

    // Calculate group propagate and generate signals for 8 groups of 4 bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : group_pg
            assign P_group[i] = &P[i*4 +: 4];                      // AND of 4 P bits
            assign G_group[i] = G[i*4 + 3] | (P[i*4 + 3] & G[i*4 + 2]) |
                              (P[i*4 + 3] & P[i*4 + 2] & G[i*4 + 1]) |
                              (P[i*4 + 3] & P[i*4 + 2] & P[i*4 + 1] & G[i*4]);
        end
    endgenerate

    // Carry lookahead logic for each 4-bit group
    assign C_group[0] = cin;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_group
            assign C_group[i+1] = G_group[i] | (P_group[i] & C_group[i]);
        end
    endgenerate

    // Within each 4-bit group, calculate carry signals for bits
    wire [31:0] C_internal; // Carry into each bit (C_internal[0] = C_group[0])
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_carry
            // 4 bits in group: bits 4*i to 4*i+3
            // Calculate internal carries for these 4 bits from group's carry-in
            assign C_internal[i*4 + 0] = C_group[i];
            assign C_internal[i*4 + 1] = G[i*4 + 0] | (P[i*4 + 0] & C_internal[i*4 + 0]);
            assign C_internal[i*4 + 2] = G[i*4 + 1] | (P[i*4 + 1] & C_internal[i*4 + 1]);
            assign C_internal[i*4 + 3] = G[i*4 + 2] | (P[i*4 + 2] & C_internal[i*4 + 2]);
        end
    endgenerate

    // Sum calculation
    assign sum = P ^ C_internal;

    // Final carry out
    assign cout = G[31] | (P[31] & C_internal[31]);

endmodule