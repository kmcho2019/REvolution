module cla_8bit(
    input  [7:0]  A,
    input  [7:0]  B,
    input         Cin,
    output [7:0]  S,
    output        Cout,
    output        PG,  // Block propagate: all bits propagate
    output        GG   // Block generate: block generates carry regardless of Cin
);
    wire [7:0] P; // propagate signals
    wire [7:0] G; // generate signals
    wire [8:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;

    // Compute carry signals inside 8-bit block (carry lookahead)
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[8] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[7:0];
    assign Cout = C[8];

    // Block propagate: all bits propagate
    assign PG = &P; 
    // Block generate: block generates carry regardless of Cin
    assign GG = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Convert 1-based to 0-based indices for internal use
    wire [7:0] A0 = A[8:1];
    wire [7:0] A1 = A[16:9];
    wire [7:0] A2 = A[24:17];
    wire [7:0] A3 = A[32:25];

    wire [7:0] B0 = B[8:1];
    wire [7:0] B1 = B[16:9];
    wire [7:0] B2 = B[24:17];
    wire [7:0] B3 = B[32:25];

    // Wires for sums and carries from 8-bit CLA blocks
    wire [7:0] S0, S1, S2, S3;
    wire C0, C1, C2, C3; // carry outs from each block
    wire PG0, PG1, PG2, PG3;
    wire GG0, GG1, GG2, GG3;

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla0(.A(A0), .B(B0), .Cin(1'b0), .S(S0), .Cout(C0), .PG(PG0), .GG(GG0));
    cla_8bit cla1(.A(A1), .B(B1), .Cin(1'b0), .S(S1), .Cout(C1), .PG(PG1), .GG(GG1));
    cla_8bit cla2(.A(A2), .B(B2), .Cin(1'b0), .S(S2), .Cout(C2), .PG(PG2), .GG(GG2));
    cla_8bit cla3(.A(A3), .B(B3), .Cin(1'b0), .S(S3), .Cout(C3), .PG(PG3), .GG(GG3));

    // Compute carries between 8-bit blocks using their group propagate and generate
    // Level-2 carry lookahead for blocks:
    wire C1_in, C2_in, C3_in, C4_out;
    assign C1_in = GG0 | (PG0 & 1'b0); // Cin = 0 at top level
    assign C2_in = GG1 | (PG1 & C1_in);
    assign C3_in = GG2 | (PG2 & C2_in);
    assign C4_out = GG3 | (PG3 & C3_in);

    // Re-instantiate 8-bit CLA with correct carries for sum calculation
    // We must feed the correct carry-ins for each block to get correct sum and cout
    // So redo the 8-bit CLAs with the computed carry-ins
    // To avoid duplication, declare intermediate wires and recalc sums.

    // The above instantiations only computed with Cin=0; now compute sums with correct carries:
    wire [7:0] S0_fresh, S1_fresh, S2_fresh, S3_fresh;
    wire C0_fresh, C1_fresh, C2_fresh, C3_fresh;

    cla_8bit cla0_fresh(.A(A0), .B(B0), .Cin(1'b0),    .S(S0_fresh), .Cout(C0_fresh), .PG(), .GG());
    cla_8bit cla1_fresh(.A(A1), .B(B1), .Cin(C1_in),   .S(S1_fresh), .Cout(C1_fresh), .PG(), .GG());
    cla_8bit cla2_fresh(.A(A2), .B(B2), .Cin(C2_in),   .S(S2_fresh), .Cout(C2_fresh), .PG(), .GG());
    cla_8bit cla3_fresh(.A(A3), .B(B3), .Cin(C3_in),   .S(S3_fresh), .Cout(C3_fresh), .PG(), .GG());

    // Concatenate outputs using 1-based indexing
    assign S[8:1]    = S0_fresh;
    assign S[16:9]   = S1_fresh;
    assign S[24:17]  = S2_fresh;
    assign S[32:25]  = S3_fresh;

    assign C32 = C3_fresh;
endmodule