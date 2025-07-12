// 4-bit carry lookahead adder
module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
);

    // Generate and propagate signals
    wire [3:0] G, P;
    assign G = A & B;
    assign P = A | B;

    // Carry signals
    wire C1, C2, C3;
    assign C1 = G[0] | (P[0] & A[0]);
    assign C2 = G[1] | (P[1] & (G[0] | (P[0] & A[0])));
    assign C3 = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & A[0]))));

    // Sum signals
    assign S[0] = A[0] ^ B[0];
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;

    // Carry-out
    assign C_out = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & A[0]))))));

endmodule


// 16-bit carry lookahead adder
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    output [15:0] S,
    output C_out
);

    // Instance four 4-bit CLA modules
    wire [3:0] S1, S2, S3, S4;
    wire C1, C2, C3;

    cla_4bit u1(
        .A(A[3:0]),
        .B(B[3:0]),
        .S(S1),
        .C_out(C1)
    );

    cla_4bit u2(
        .A(A[7:4]),
        .B(B[7:4]),
        .S(S2),
        .C_out(C2)
    );

    cla_4bit u3(
        .A(A[11:8]),
        .B(B[11:8]),
        .S(S3),
        .C_out(C3)
    );

    cla_4bit u4(
        .A(A[15:12]),
        .B(B[15:12]),
        .S(S4),
        .C_out(C_out)
    );

    // Connect carry signals
    assign u2.A[0] = C1;
    assign u3.A[0] = C2;
    assign u4.A[0] = C3;

    // Output sum
    assign S[3:0] = S1;
    assign S[7:4] = S2;
    assign S[11:8] = S3;
    assign S[15:12] = S4;

endmodule


// Top-level 32-bit carry lookahead adder
module adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

    // Instance two 16-bit CLA modules
    wire [15:0] S1, S2;
    wire C1;

    cla_16bit u1(
        .A(A[15:0]),
        .B(B[15:0]),
        .S(S1),
        .C_out(C1)
    );

    cla_16bit u2(
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S2),
        .C_out(C32)
    );

    // Connect carry signal
    assign u2.A[0] = C1;

    // Output sum
    assign S[15:0] = S1;
    assign S[31:16] = S2;

endmodule