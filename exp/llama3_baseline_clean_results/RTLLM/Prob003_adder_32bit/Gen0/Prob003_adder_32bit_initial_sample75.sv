// 4-bit Carry-Lookahead Adder
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire G0, G1, G2, G3;
    wire P0, P1, P2, P3;
    wire C1, C2, C3;

    // Calculate Generate (G) and Propagate (P) signals
    assign G0 = A[0] & B[0];
    assign G1 = A[1] & B[1];
    assign G2 = A[2] & B[2];
    assign G3 = A[3] & B[3];
    assign P0 = A[0] | B[0];
    assign P1 = A[1] | B[1];
    assign P2 = A[2] | B[2];
    assign P3 = A[3] | B[3];

    // Calculate carry signals
    assign C1 = G0 | (P0 & Cin);
    assign C2 = G1 | (P1 & C1);
    assign C3 = G2 | (P2 & C2);

    // Calculate sum signals
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;

    assign Cout = G3 | (P3 & C3);
endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire G0, G1, G2, G3;
    wire P0, P1, P2, P3;
    wire C4, C8, C12;

    // Calculate Generate (G) and Propagate (P) signals for each group of 4 bits
    assign G0 = (A[3] & B[3]) | (A[2] & B[2]) | (A[1] & B[1]) | (A[0] & B[0]);
    assign G1 = (A[7] & B[7]) | (A[6] & B[6]) | (A[5] & B[5]) | (A[4] & B[4]);
    assign G2 = (A[11] & B[11]) | (A[10] & B[10]) | (A[9] & B[9]) | (A[8] & B[8]);
    assign G3 = (A[15] & B[15]) | (A[14] & B[14]) | (A[13] & B[13]) | (A[12] & B[12]);
    assign P0 = (A[3] | B[3]) & (A[2] | B[2]) & (A[1] | B[1]) & (A[0] | B[0]);
    assign P1 = (A[7] | B[7]) & (A[6] | B[6]) & (A[5] | B[5]) & (A[4] | B[4]);
    assign P2 = (A[11] | B[11]) & (A[10] | B[10]) & (A[9] | B[9]) & (A[8] | B[8]);
    assign P3 = (A[15] | B[15]) & (A[14] | B[14]) & (A[13] | B[13]) & (A[12] | B[12]);

    // Calculate carry signals between groups of 4 bits
    assign C4 = G0 | (P0 & Cin);
    assign C8 = G1 | (P1 & C4);
    assign C12 = G2 | (P2 & C8);

    // Instantiate 4-bit CLA modules for each group of 4 bits
    cla_4bit u0(A[3:0], B[3:0], Cin, S[3:0], C4);
    cla_4bit u1(A[7:4], B[7:4], C4, S[7:4], C8);
    cla_4bit u2(A[11:8], B[11:8], C8, S[11:8], C12);
    cla_4bit u3(A[15:12], B[15:12], C12, S[15:12], Cout);
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire C16;

    // Instantiate two 16-bit CLA modules
    cla_16bit u0(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit u1(A[32:17], B[32:17], C16, S[32:17], C32);
endmodule