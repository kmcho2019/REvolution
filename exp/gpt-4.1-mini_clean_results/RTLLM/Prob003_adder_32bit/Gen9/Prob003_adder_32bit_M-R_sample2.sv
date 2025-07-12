module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] P; // Propagate bits
    wire [15:0] G; // Generate bits

    assign P = A ^ B;
    assign G = A & B;

    // Group propagate and generate signals for 4-bit groups
    wire [3:0] P_group;
    wire [3:0] G_group;

    // Compute group propagate: all propagate bits in group
    assign P_group[0] = &P[3:0];
    assign P_group[1] = &P[7:4];
    assign P_group[2] = &P[11:8];
    assign P_group[3] = &P[15:12];

    // Compute group generate: generate or propagate & generate chain within group
    assign G_group[0] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign G_group[1] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    assign G_group[2] = G[11] | (P[11] & G[10]) | (P[11] & P[10] & G[9]) | (P[11] & P[10] & P[9] & G[8]);
    assign G_group[3] = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & G[12]);

    // Compute carry for each group
    wire [4:0] C_group; // carry in at group boundaries
    assign C_group[0] = Cin;
    genvar gi;
    generate
        for (gi = 1; gi < 5; gi = gi + 1) begin : group_carry
            assign C_group[gi] = G_group[gi-1] | (P_group[gi-1] & C_group[gi-1]);
        end
    endgenerate

    // Compute carries inside each 4-bit group using generate and propagate bits
    wire [16:0] C; // carry bits for each bit plus Cin

    assign C[0] = Cin;

    // For group 0: bits 0 to 3
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G_group[0] | (P_group[0] & C_group[0]); // same as C_group[1]

    // For group 1: bits 4 to 7
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & C[4]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & C[4]);
    assign C[8] = G_group[1] | (P_group[1] & C_group[1]); // same as C_group[2]

    // For group 2: bits 8 to 11
    assign C[9]  = G[8]  | (P[8]  & C[8]);
    assign C[10] = G[9]  | (P[9]  & G[8]) | (P[9]  & P[8]  & C[8]);
    assign C[11] = G[10] | (P[10] & G[9]) | (P[10] & P[9]  & G[8]) | (P[10] & P[9] & P[8] & C[8]);
    assign C[12] = G_group[2] | (P_group[2] & C_group[2]); // same as C_group[3]

    // For group 3: bits 12 to 15
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G[13] | (P[13] & G[12]) | (P[13] & P[12] & C[12]);
    assign C[15] = G[14] | (P[14] & G[13]) | (P[14] & P[13] & G[12]) | (P[14] & P[13] & P[12] & C[12]);
    assign C[16] = G_group[3] | (P_group[3] & C_group[3]); // same as Cout

    // Compute sum bits
    assign S = P ^ C[15:0];
    assign Cout = C[16];

endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);

    // Convert 1-based input to zero-based for CLA instances
    wire [15:0] A_low  = A[16:1];
    wire [15:0] B_low  = B[16:1];
    wire [15:0] A_high = A[32:17];
    wire [15:0] B_high = B[32:17];

    wire [15:0] S_low;
    wire [15:0] S_high;
    wire c16;

    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(c16)
    );

    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(c16),
        .S(S_high),
        .Cout(C32)
    );

    // Map zero-based CLA outputs back to 1-based top-level outputs
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;

endmodule