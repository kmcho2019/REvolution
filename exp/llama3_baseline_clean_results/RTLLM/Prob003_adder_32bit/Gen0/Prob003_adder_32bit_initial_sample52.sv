// 4-bit CLA block
module cla_4bit(A, B, Cin, S, Cout);
    input [4:1] A, B;
    input Cin;
    output [4:1] S;
    output Cout;

    wire [4:1] G, P;
    wire [4:1] C;

    // Calculate generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] ^ B[4];

    // Calculate carry signals
    assign C[1] = Cin;
    assign C[2] = G[1] | (P[1] & Cin);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    // Calculate sum signals
    assign S[1] = P[1] ^ Cin;
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];
    assign S[4] = P[4] ^ C[4];

    assign Cout = G[4] | (P[4] & C[4]);
endmodule

// 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A, B;
    input Cin;
    output [16:1] S;
    output Cout;

    wire Cout1, Cout2, Cout3, Cout4;
    wire [4:1] A1, A2, A3, A4, B1, B2, B3, B4;
    wire [4:1] S1, S2, S3, S4;

    assign A1 = A[4:1];
    assign A2 = A[8:5];
    assign A3 = A[12:9];
    assign A4 = A[16:13];
    assign B1 = B[4:1];
    assign B2 = B[8:5];
    assign B3 = B[12:9];
    assign B4 = B[16:13];

    cla_4bit u1(A1, B1, Cin, S1, Cout1);
    cla_4bit u2(A2, B2, Cout1, S2, Cout2);
    cla_4bit u3(A3, B3, Cout2, S3, Cout3);
    cla_4bit u4(A4, B4, Cout3, S4, Cout4);

    assign S[4:1] = S1;
    assign S[8:5] = S2;
    assign S[12:9] = S3;
    assign S[16:13] = S4;

    assign Cout = Cout4;
endmodule

// 32-bit CLA adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire C16;

    cla_16bit u1(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit u2(A[32:17], B[32:17], C16, S[32:17], C32);
endmodule