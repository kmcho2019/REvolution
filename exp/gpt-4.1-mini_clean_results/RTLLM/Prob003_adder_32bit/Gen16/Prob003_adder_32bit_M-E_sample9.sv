module cla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        Cin,
    output wire [7:0]  S,
    output wire        Cout,
    output wire        P,    // Block propagate
    output wire        G     // Block generate
);
    wire [7:0] P_bit = A ^ B;  // Propagate signals per bit
    wire [7:0] G_bit = A & B;  // Generate signals per bit

    // Carry lookahead logic:
    // Compute carries C[0] to C[8], where C[0] = Cin
    wire [8:0] C;
    assign C[0] = Cin;

    // Compute carries explicitly via carry-lookahead formulas:
    assign C[1] = G_bit[0] | (P_bit[0] & C[0]);
    assign C[2] = G_bit[1] | (P_bit[1] & G_bit[0]) | (P_bit[1] & P_bit[0] & C[0]);
    assign C[3] = G_bit[2] | (P_bit[2] & G_bit[1]) | (P_bit[2] & P_bit[1] & G_bit[0]) | (P_bit[2] & P_bit[1] & P_bit[0] & C[0]);
    assign C[4] = G_bit[3] | (P_bit[3] & G_bit[2]) | (P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]) | (P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0] & C[0]);
    assign C[5] = G_bit[4] | (P_bit[4] & G_bit[3]) | (P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]) | (P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0] & C[0]);
    assign C[6] = G_bit[5] | (P_bit[5] & G_bit[4]) | (P_bit[5] & P_bit[4] & G_bit[3]) | (P_bit[5] & P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]) | (P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0] & C[0]);
    assign C[7] = G_bit[6] | (P_bit[6] & G_bit[5]) | (P_bit[6] & P_bit[5] & G_bit[4]) | (P_bit[6] & P_bit[5] & P_bit[4] & G_bit[3]) | (P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]) | (P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0] & C[0]);
    assign C[8] = G_bit[7] | (P_bit[7] & G_bit[6]) | (P_bit[7] & P_bit[6] & G_bit[5]) | (P_bit[7] & P_bit[6] & P_bit[5] & G_bit[4]) | (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & G_bit[3]) | (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]) | (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0] & C[0]);

    assign S = P_bit ^ C[7:0];
    assign Cout = C[8];

    // Block propagate is AND of all bit propagates
    assign P = &P_bit;

    // Block generate is the carry-out when Cin=0, so G = C[8] when Cin=0
    // Since C[8] depends on Cin, compute G separately:
    // G = G7 | (P7 & G6) | ... as in the carry expression with Cin=0
    wire G0 = 1'b0; // For clarity in reduction
    wire G1 = G_bit[0] | (P_bit[0] & G0);
    wire G2 = G_bit[1] | (P_bit[1] & G1);
    wire G3 = G_bit[2] | (P_bit[2] & G2);
    wire G4 = G_bit[3] | (P_bit[3] & G3);
    wire G5 = G_bit[4] | (P_bit[4] & G4);
    wire G6 = G_bit[5] | (P_bit[5] & G5);
    wire G7 = G_bit[6] | (P_bit[6] & G6);
    wire G8 = G_bit[7] | (P_bit[7] & G7);

    assign G = G8;
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs to zero-based vectors internally
    wire [31:0] A_int = A[32:1];
    wire [31:0] B_int = B[32:1];

    // Divide into four 8-bit chunks: bits [7:0], [15:8], [23:16], [31:24]
    wire [7:0]  A0 = A_int[7:0];
    wire [7:0]  A1 = A_int[15:8];
    wire [7:0]  A2 = A_int[23:16];
    wire [7:0]  A3 = A_int[31:24];

    wire [7:0]  B0 = B_int[7:0];
    wire [7:0]  B1 = B_int[15:8];
    wire [7:0]  B2 = B_int[23:16];
    wire [7:0]  B3 = B_int[31:24];

    // Internal wires for sums and carries
    wire [7:0]  S0, S1, S2, S3;
    wire        C1, C2, C3, C4;
    wire        P0, G0;
    wire        P1, G1;
    wire        P2, G2;
    wire        P3, G3;

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla0 (
        .A(A0),
        .B(B0),
        .Cin(1'b0),
        .S(S0),
        .Cout(C1),
        .P(P0),
        .G(G0)
    );

    // Carry into block 1
    wire C_in1 = G0 | (P0 & 1'b0); // global Cin=0

    cla_8bit cla1 (
        .A(A1),
        .B(B1),
        .Cin(C_in1),
        .S(S1),
        .Cout(C2),
        .P(P1),
        .G(G1)
    );

    // Carry into block 2
    wire C_in2 = G1 | (P1 & C_in1);

    cla_8bit cla2 (
        .A(A2),
        .B(B2),
        .Cin(C_in2),
        .S(S2),
        .Cout(C3),
        .P(P2),
        .G(G2)
    );

    // Carry into block 3
    wire C_in3 = G2 | (P2 & C_in2);

    cla_8bit cla3 (
        .A(A3),
        .B(B3),
        .Cin(C_in3),
        .S(S3),
        .Cout(C4),
        .P(P3),
        .G(G3)
    );

    // Final carry out
    assign C32 = C4;

    // Concatenate sums and map back to 1-based output range
    assign S[8:1]    = S0;
    assign S[16:9]   = S1;
    assign S[24:17]  = S2;
    assign S[32:25]  = S3;

endmodule