module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P_out, // Group propagate
    output        G_out  // Group generate
);
    wire [16:1] P; // propagate for each bit
    wire [16:1] G; // generate for each bit
    wire [16:0] C; // carry signals, C[0]=Cin

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;

    // Carry lookahead logic:
    // C[i] = G[i] | (P[i] & C[i-1])
    genvar i;
    generate
        for (i = 1; i <= 16; i = i+1) begin : carry_calc
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    assign S = P ^ C[15:0];

    assign Cout = C[16];

    // Group propagate: P_out = P1&P2&...&P16
    assign P_out = &P;

    // Group generate: G_out = G16 | (P16&G15) | (P16&P15&G14) | ... | (P16&P15...P2&G1)
    // We'll implement using a recursive formula:
    // G_out = G16 + P16*G15 + P16*P15*G14 + ... + P16*...*P2*G1
    wire [16:1] carry_gen_terms;
    wire [16:1] prop_chain;

    assign prop_chain[1] = P[1];
    assign carry_gen_terms[1] = G[1];
    genvar j;
    generate
        for (j = 2; j <= 16; j = j+1) begin : group_gen_prop
            assign prop_chain[j] = prop_chain[j-1] & P[j];
            assign carry_gen_terms[j] = G[j] & prop_chain[j-1];
        end
    endgenerate

    assign G_out = |carry_gen_terms;

endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P0, G0;
    wire P1, G1;

    // Lower 16 bits CLA
    cla_16bit cla_lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .P_out(P0),
        .G_out(G0)
    );

    // Compute carry-in for upper 16 bits using CLA carry logic
    // Carry_in_16 = G0 | (P0 & Cin) = G0 since Cin=0
    wire Cin_upper = G0 | (P0 & 1'b0); // effectively G0

    // Upper 16 bits CLA
    cla_16bit cla_upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cin_upper),
        .S(S[32:17]),
        .Cout(C32),
        .P_out(P1),
        .G_out(G1)
    );

endmodule