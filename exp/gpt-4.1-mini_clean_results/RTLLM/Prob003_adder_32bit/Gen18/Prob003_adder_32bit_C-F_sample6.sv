module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout,
    output        GG,  // Block generate
    output        GP   // Block propagate
);
    wire [15:0] G = A & B;      // Generate signals
    wire [15:0] P = A ^ B;      // Propagate signals
    wire [16:0] C;              // Carry signals

    assign C[0] = Cin;

    // Explicit carry assignments for clarity and possible optimization
    assign C[1]  = G[0]  | (P[0]  & C[0]);
    assign C[2]  = G[1]  | (P[1]  & C[1]);
    assign C[3]  = G[2]  | (P[2]  & C[2]);
    assign C[4]  = G[3]  | (P[3]  & C[3]);
    assign C[5]  = G[4]  | (P[4]  & C[4]);
    assign C[6]  = G[5]  | (P[5]  & C[5]);
    assign C[7]  = G[6]  | (P[6]  & C[6]);
    assign C[8]  = G[7]  | (P[7]  & C[7]);
    assign C[9]  = G[8]  | (P[8]  & C[8]);
    assign C[10] = G[9]  | (P[9]  & C[9]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G[11] | (P[11] & C[11]);
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & C[14]);
    assign C[16] = G[15] | (P[15] & C[15]);

    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: all bits propagate
    assign GP = &P;

    // Block generate: either generate from MSB or propagate all with carry in generate
    assign GG = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & G[12]) |
                (P[15] & P[14] & P[13] & P[12] & G[11]) | (P[15] & P[14] & P[13] & P[12] & P[11] & G[10]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & G[9]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & G[8]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & G[7]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & G[6]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & G[5]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & G[4]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_32bit(
    input  [32:1] A,   // 1-based index inputs as per problem statement
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Map 1-based indexing to 0-based internal signals for convenience
    wire [15:0] A_lower = A[16:1];
    wire [15:0] B_lower = B[16:1];
    wire [15:0] A_upper = A[32:17];
    wire [15:0] B_upper = B[32:17];
    wire [15:0] S_lower;
    wire [15:0] S_upper;
    wire C16_lower, GP_lower, GG_lower;

    // Lower 16-bit CLA block
    cla_16bit cla_lower (
        .A(A_lower),
        .B(B_lower),
        .Cin(1'b0),
        .S(S_lower),
        .Cout(C16_lower),
        .GP(GP_lower),
        .GG(GG_lower)
    );

    // Calculate carry-in for upper block using block generate and propagate
    wire C16 = GG_lower | (GP_lower & 1'b0);  // Cin is zero for lower block, so carry-in of lower is zero

    // Upper 16-bit CLA block
    wire GP_upper, GG_upper;
    wire C16_upper;

    cla_16bit cla_upper (
        .A(A_upper),
        .B(B_upper),
        .Cin(C16_lower),
        .S(S_upper),
        .Cout(C32),
        .GP(GP_upper),
        .GG(GG_upper)
    );

    // Assign outputs with 1-based index
    assign S[16:1]  = S_lower;
    assign S[32:17] = S_upper;
endmodule