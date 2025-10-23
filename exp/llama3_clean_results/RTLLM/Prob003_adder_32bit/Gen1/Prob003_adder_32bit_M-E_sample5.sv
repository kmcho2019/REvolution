// 2-bit adder
module adder_2bit(
    input [2:1] A,
    input [2:1] B,
    output [2:1] S,
    output C_out,
    output P,
    output G
);
    assign S[1] = A[1] ^ B[1];
    assign C_out = (A[1] & B[1]) | (A[1] & A[2]) | (B[1] & A[2]);
    assign S[2] = A[2] ^ B[2] ^ C_out;
    assign P = A[1] ^ B[1];
    assign G = A[1] & B[1];
endmodule

// 8-bit carry-lookahead adder using 2-bit adders
module adder_8bit(
    input [8:1] A,
    input [8:1] B,
    output [8:1] S,
    output C_out
);
    wire [2:1] P1, P2, P3, P4;
    wire [2:1] G1, G2, G3, G4;
    wire C1, C2, C3;
    adder_2bit add1(
        .A(A[2:1]),
        .B(B[2:1]),
        .S(S[2:1]),
        .C_out(C1),
        .P(P1),
        .G(G1)
    );
    adder_2bit add2(
        .A(A[4:3]),
        .B(B[4:3]),
        .S(S[4:3]),
        .C_out(C2),
        .P(P2),
        .G(G2)
    );
    adder_2bit add3(
        .A(A[6:5]),
        .B(B[6:5]),
        .S(S[6:5]),
        .C_out(C3),
        .P(P3),
        .G(G3)
    );
    adder_2bit add4(
        .A(A[8:7]),
        .B(B[8:7]),
        .S(S[8:7]),
        .C_out(C_out),
        .P(P4),
        .G(G4)
    );
    // Compute the carry-in for each 2-bit block using the propagate and generate signals
    assign S[3] = A[3] ^ B[3] ^ (P1[1] & G1[1]);
    assign S[5] = A[5] ^ B[5] ^ (P2[1] & G2[1]);
    assign S[7] = A[7] ^ B[7] ^ (P3[1] & G3[1]);
endmodule

// 32-bit carry-lookahead adder using 8-bit adders
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16, C24, C32_temp;
    adder_8bit add1(
        .A(A[8:1]),
        .B(B[8:1]),
        .S(S[8:1]),
        .C_out(C8)
    );
    adder_8bit add2(
        .A(A[16:9]),
        .B(B[16:9]),
        .S(S[16:9]),
        .C_out(C16)
    );
    adder_8bit add3(
        .A(A[24:17]),
        .B(B[24:17]),
        .S(S[24:17]),
        .C_out(C24)
    );
    adder_8bit add4(
        .A(A[32:25]),
        .B(B[32:25]),
        .S(S[32:25]),
        .C_out(C32_temp)
    );
    // Compute the final carry-out
    assign C32 = C32_temp;
endmodule