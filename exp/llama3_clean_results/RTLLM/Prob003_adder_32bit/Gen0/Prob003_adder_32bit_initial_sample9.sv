// 4-bit CLA module
module cla_4bit(A, B, Cin, S, Cout);
    input [4:1] A, B;
    input Cin;
    output [4:1] S;
    output Cout;
    wire [4:1] G, P;
    wire C1, C2, C3, C4;

    // Calculate G and P signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] ^ B[4];

    // Calculate carry signals
    assign C1 = Cin | (P[1] & G[1]);
    assign C2 = C1 | (P[2] & G[2]);
    assign C3 = C2 | (P[3] & G[3]);
    assign C4 = C3 | (P[4] & G[4]);

    assign Cout = C4;

    // Calculate sum signals
    assign S[1] = A[1] ^ B[1] ^ Cin;
    assign S[2] = A[2] ^ B[2] ^ C1;
    assign S[3] = A[3] ^ B[3] ^ C2;
    assign S[4] = A[4] ^ B[4] ^ C3;
endmodule

// 16-bit CLA module
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A, B;
    input Cin;
    output [16:1] S;
    output Cout;
    wire [4:1] G, P;
    wire C1, C2, C3, C4;
    wire [4:1] A1, A2, A3, A4;
    wire [4:1] B1, B2, B3, B4;
    wire [4:1] S1, S2, S3, S4;

    assign A1 = A[4:1];
    assign A2 = A[8:5];
    assign A3 = A[12:9];
    assign A4 = A[16:13];
    assign B1 = B[4:1];
    assign B2 = B[8:5];
    assign B3 = B[12:9];
    assign B4 = B[16:13];

    cla_4bit u1(A1, B1, Cin, S1, C1);
    cla_4bit u2(A2, B2, C1, S2, C2);
    cla_4bit u3(A3, B3, C2, S3, C3);
    cla_4bit u4(A4, B4, C3, S4, C4);

    assign Cout = C4;

    assign S[4:1] = S1;
    assign S[8:5] = S2;
    assign S[12:9] = S3;
    assign S[16:13] = S4;
endmodule

// 32-bit CLA module
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;
    wire [16:1] A1, A2;
    wire [16:1] B1, B2;
    wire [16:1] S1, S2;
    wire C16;

    assign A1 = A[16:1];
    assign A2 = A[32:17];
    assign B1 = B[16:1];
    assign B2 = B[32:17];

    cla_16bit u1(A1, B1, 1'b0, S1, C16);
    cla_16bit u2(A2, B2, C16, S2, C32);

    assign S[16:1] = S1;
    assign S[32:17] = S2;
endmodule