module cla_16bit(
    input  wire [16:1] A,
    input  wire [16:1] B,
    input  wire        Cin,
    output wire [16:1] S,
    output wire        Cout,
    output wire        P_block, // group propagate
    output wire        G_block  // group generate
);
    wire [16:1] P; // propagate signals for each bit
    wire [16:1] G; // generate signals for each bit
    wire [16:0] C; // carry signals (C[0] = Cin)

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Explicit carry assignments for clarity and synthesis friendliness
    assign C[1]  = G[1]  | (P[1]  & C[0]);
    assign C[2]  = G[2]  | (P[2]  & C[1]);
    assign C[3]  = G[3]  | (P[3]  & C[2]);
    assign C[4]  = G[4]  | (P[4]  & C[3]);
    assign C[5]  = G[5]  | (P[5]  & C[4]);
    assign C[6]  = G[6]  | (P[6]  & C[5]);
    assign C[7]  = G[7]  | (P[7]  & C[6]);
    assign C[8]  = G[8]  | (P[8]  & C[7]);
    assign C[9]  = G[9]  | (P[9]  & C[8]);
    assign C[10] = G[10] | (P[10] & C[9]);
    assign C[11] = G[11] | (P[11] & C[10]);
    assign C[12] = G[12] | (P[12] & C[11]);
    assign C[13] = G[13] | (P[13] & C[12]);
    assign C[14] = G[14] | (P[14] & C[13]);
    assign C[15] = G[15] | (P[15] & C[14]);
    assign C[16] = G[16] | (P[16] & C[15]);

    assign S = P ^ C[15:0];

    assign Cout = C[16];

    // Group propagate: AND of all bit propagates
    assign P_block = &P;

    // Group generate computed recursively:
    wire [16:1] gen_intermediate;
    assign gen_intermediate[1] = G[1];
    genvar i;
    generate
        for (i = 2; i <= 16; i = i + 1) begin : gen_loop
            assign gen_intermediate[i] = G[i] | (P[i] & gen_intermediate[i-1]);
        end
    endgenerate
    assign G_block = gen_intermediate[16];

endmodule

module adder_32bit(
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);

    // Split inputs for lower and upper 16-bit blocks
    wire [16:1] A_low  = A[16:1];
    wire [16:1] B_low  = B[16:1];
    wire [16:1] A_high = A[32:17];
    wire [16:1] B_high = B[32:17];

    wire [16:1] S_low;
    wire [16:1] S_high;

    wire C16;       // Carry-out from lower block
    wire P0, G0;    // Propagate and generate from lower block
    wire P1, G1;    // Propagate and generate from upper block

    // Instantiate lower 16-bit CLA block
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Calculate carry-in for upper block
    // Carry_in_upper = G0 | (P0 & 0) = G0
    wire Cin_high = G0;

    // Instantiate upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P_block(P1),
        .G_block(G1)
    );

    // Concatenate results preserving [32:1] bit ordering
    assign S[16:1]   = S_low;
    assign S[32:17]  = S_high;

endmodule