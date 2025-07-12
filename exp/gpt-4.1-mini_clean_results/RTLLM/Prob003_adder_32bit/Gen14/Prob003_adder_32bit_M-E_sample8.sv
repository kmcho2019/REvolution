module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P_out,  // Group propagate
    output       G_out   // Group generate
);
    wire [4:1] P, G;
    wire [4:0] C;

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group propagate is AND of all P
    assign P_out = &P;
    // Group generate is G4 + P4*G3 + P4*P3*G2 + P4*P3*P2*G1
    assign G_out = G[4] |
                   (P[4] & G[3]) |
                   (P[4] & P[3] & G[2]) |
                   (P[4] & P[3] & P[2] & G[1]);
endmodule

module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [4:1] P_group, G_group; // Group propagate and generate for 4 groups
    wire [4:0] C_group;          // Carry signals at group boundaries
    assign C_group[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i +1) begin : cla4_blocks
            cla_4bit cla4_inst (
                .A       (A[i*4 +: 4]),
                .B       (B[i*4 +: 4]),
                .Cin     (C_group[i]),
                .S       (S[i*4 +: 4]),
                .Cout    (),
                .P_out   (P_group[i+1]),
                .G_out   (G_group[i+1])
            );
        end
    endgenerate

    // Compute carry into each group using hierarchical CLA logic
    // C_group[i+1] = G_group[i+1] | (P_group[i+1] & C_group[i])
    // i from 0 to 3

    assign C_group[1] = G_group[1] | (P_group[1] & C_group[0]);
    assign C_group[2] = G_group[2] | (P_group[2] & C_group[1]);
    assign C_group[3] = G_group[3] | (P_group[3] & C_group[2]);
    assign C_group[4] = G_group[4] | (P_group[4] & C_group[3]);

    assign Cout = C_group[4];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule