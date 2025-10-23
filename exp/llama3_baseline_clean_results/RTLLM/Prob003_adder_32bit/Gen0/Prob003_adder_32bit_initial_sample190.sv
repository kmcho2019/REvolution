// 4-bit CLA block
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] P, G;
    wire [2:0] C;

    // Compute P and G signals
    assign P[0] = A[0] ^ B[0];
    assign G[0] = A[0] & B[0];
    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    assign P[2] = A[2] ^ B[2];
    assign G[2] = A[2] & B[2];
    assign P[3] = A[3] ^ B[3];
    assign G[3] = A[3] & B[3];

    // Compute carry signals
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);

    // Compute sum signals
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C[0];
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];

    // Compute carry-out
    assign Cout = G[3] | (P[3] & C[2]);
endmodule

// 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [3:0] P, G;
    wire [3:0] C;
    wire [15:0] S_temp;

    // Split 16-bit inputs into 4 groups of 4-bit
    wire [3:0] A0, A1, A2, A3;
    wire [3:0] B0, B1, B2, B3;
    assign A0 = A[3:0];
    assign A1 = A[7:4];
    assign A2 = A[11:8];
    assign A3 = A[15:12];
    assign B0 = B[3:0];
    assign B1 = B[7:4];
    assign B2 = B[11:8];
    assign B3 = B[15:12];

    // Instantiate 4-bit CLA blocks
    cla_4bit cla0(A0, B0, Cin, S_temp[3:0], C[0]);
    cla_4bit cla1(A1, B1, C[0], S_temp[7:4], C[1]);
    cla_4bit cla2(A2, B2, C[1], S_temp[11:8], C[2]);
    cla_4bit cla3(A3, B3, C[2], S_temp[15:12], C[3]);

    // Assign sum and carry-out
    assign S = S_temp;
    assign Cout = C[3];
endmodule

// 32-bit adder using two 16-bit CLA blocks
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;

    wire [15:0] A0, A1;
    wire [15:0] B0, B1;
    wire C16;
    wire [15:0] S0, S1;

    assign A0 = A[15:1];
    assign A1 = A[31:16];
    assign B0 = B[15:1];
    assign B1 = B[31:16];

    cla_16bit cla0(A0, B0, 1'b0, S0, C16);
    cla_16bit cla1(A1, B1, C16, S1, C32);

    assign S[15:1] = S0;
    assign S[31:16] = S1;
endmodule