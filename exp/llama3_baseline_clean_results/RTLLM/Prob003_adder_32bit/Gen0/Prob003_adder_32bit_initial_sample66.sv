// Define the 4-bit CLA block
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;

    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign C[0] = Cin;

    assign S[0] = A[0] ^ B[0] ^ Cin;

    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign C[1] = G[0] | (P[0] & C[0]);

    assign S[1] = A[1] ^ B[1] ^ C[0];

    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign C[2] = G[1] | (P[1] & C[1]);

    assign S[2] = A[2] ^ B[2] ^ C[1];

    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    assign C[3] = G[2] | (P[2] & C[2]);

    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign Cout = G[3] | (P[3] & C[3]);
endmodule

// Define the 8-bit CLA block
module cla_8bit(A, B, Cin, S, Cout);
    input [7:0] A;
    input [7:0] B;
    input Cin;
    output [7:0] S;
    output Cout;

    wire C4;
    cla_4bit cla_low(A[3:0], B[3:0], Cin, S[3:0], C4);
    cla_4bit cla_high(A[7:4], B[7:4], C4, S[7:4], Cout);
endmodule

// Define the 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire C8;
    cla_8bit cla_low(A[7:0], B[7:0], Cin, S[7:0], C8);
    cla_8bit cla_high(A[15:8], B[15:8], C8, S[15:8], Cout);
endmodule

// Define the 32-bit CLA block
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;

    wire C16;
    cla_16bit cla_low(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla_high(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule