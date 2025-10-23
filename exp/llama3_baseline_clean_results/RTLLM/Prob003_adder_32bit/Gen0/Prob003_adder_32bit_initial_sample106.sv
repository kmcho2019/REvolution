// 4-bit CLA block
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] G, P;
    wire [2:0] C;

    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign C[0] = Cin;

    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign C[1] = G[0] | (P[0] & Cin);

    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];

    assign S[1] = A[1] ^ B[1] ^ C[0];
    assign C[2] = G[1] | (P[1] & C[1]);

    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];

    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign C[3] = G[2] | (P[2] & C[2]);

    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];

    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign Cout = G[3] | (P[3] & C[3]);
endmodule

// 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [3:0] G, P;
    wire [15:0] S_temp;
    wire [3:0] Cin_temp;

    cla_4bit cla_4bit_0(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S_temp[3:0]), .Cout(Cin_temp[0]));
    cla_4bit cla_4bit_1(.A(A[7:4]), .B(B[7:4]), .Cin(Cin_temp[0]), .S(S_temp[7:4]), .Cout(Cin_temp[1]));
    cla_4bit cla_4bit_2(.A(A[11:8]), .B(B[11:8]), .Cin(Cin_temp[1]), .S(S_temp[11:8]), .Cout(Cin_temp[2]));
    cla_4bit cla_4bit_3(.A(A[15:12]), .B(B[15:12]), .Cin(Cin_temp[2]), .S(S_temp[15:12]), .Cout(Cout));

    assign S = S_temp;
endmodule

// 32-bit CLA
module adder_32bit(A, B, S, C32);
    input [31:0] A;
    input [31:0] B;
    output [31:0] S;
    output C32;

    wire [15:0] S_low;
    wire Cout_low;

    cla_16bit cla_16bit_0(.A(A[15:0]), .B(B[15:0]), .Cin(1'b0), .S(S_low), .Cout(Cout_low));
    cla_16bit cla_16bit_1(.A(A[31:16]), .B(B[31:16]), .Cin(Cout_low), .S(S[31:16]), .Cout(C32));

    assign S[15:0] = S_low;
endmodule