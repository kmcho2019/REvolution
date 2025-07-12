module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P; // Propagate signals
    wire [16:1] G; // Generate signals
    wire [16:0] C; // Carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Generate carry signals using CLA logic in 4-bit groups
    wire [3:0] P_group, G_group;
    genvar i;

    // Group propagate and generate signals for four 4-bit blocks
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg
            assign P_group[i] = &P[4*i+4:4*i+1]; // group propagate = AND of 4 bits P
            assign G_group[i] = G[4*i+4] | (P[4*i+4] & G[4*i+3]) | 
                                (P[4*i+4] & P[4*i+3] & G[4*i+2]) | 
                                (P[4*i+4] & P[4*i+3] & P[4*i+2] & G[4*i+1]);
        end
    endgenerate

    // Carry into each group
    wire [4:0] C_group;
    assign C_group[0] = Cin;
    assign C_group[1] = G_group[0] | (P_group[0] & C_group[0]);
    assign C_group[2] = G_group[1] | (P_group[1] & C_group[1]);
    assign C_group[3] = G_group[2] | (P_group[2] & C_group[2]);
    assign C_group[4] = G_group[3] | (P_group[3] & C_group[3]);

    // Now compute carry bits inside each 4-bit group
    // Using the CLA carry formulas for each bit
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_carry
            wire [4:1] Pi = P[4*i+4:4*i+1];
            wire [4:1] Gi = G[4*i+4:4*i+1];
            wire Cin_group = C_group[i];

            assign C[4*i+1] = Gi[1] | (Pi[1] & Cin_group);
            assign C[4*i+2] = Gi[2] | (Pi[2] & Gi[1]) | (Pi[2] & Pi[1] & Cin_group);
            assign C[4*i+3] = Gi[3] | (Pi[3] & Gi[2]) | (Pi[3] & Pi[2] & Gi[1]) | (Pi[3] & Pi[2] & Pi[1] & Cin_group);
            assign C[4*i+4] = Gi[4] | (Pi[4] & Gi[3]) | (Pi[4] & Pi[3] & Gi[2]) |
                              (Pi[4] & Pi[3] & Pi[2] & Gi[1]) |
                              (Pi[4] & Pi[3] & Pi[2] & Pi[1] & Cin_group);
        end
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit lower_half (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit upper_half (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule