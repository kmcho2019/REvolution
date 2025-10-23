// 4-bit carry-lookahead adder
module cla_4bit(A, B, C_in, S, C_out);
    input [3:0] A;
    input [3:0] B;
    input C_in;
    output [3:0] S;
    output C_out;
    wire [3:0] P, G;
    wire C1, C2, C3;

    // Calculate P and G
    assign P[0] = A[0] ^ B[0];
    assign G[0] = A[0] & B[0];
    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    assign P[2] = A[2] ^ B[2];
    assign G[2] = A[2] & B[2];
    assign P[3] = A[3] ^ B[3];
    assign G[3] = A[3] & B[3];

    // Calculate C
    assign C1 = G[0] | (P[0] & C_in);
    assign C2 = G[1] | (P[1] & (G[0] | (P[0] & C_in)));
    assign C3 = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))));
    assign C_out = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))));

    // Calculate S
    assign S[0] = A[0] ^ B[0] ^ C_in;
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(A, B, C_in, S, C_out);
    input [15:0] A;
    input [15:0] B;
    input C_in;
    output [15:0] S;
    output C_out;
    wire [3:0] P, G;
    wire [3:0] C;
    wire C1, C2, C3;

    cla_4bit cla0(A[3:0], B[3:0], C_in, S[3:0], C1);
    cla_4bit cla1(A[7:4], B[7:4], C1, S[7:4], C2);
    cla_4bit cla2(A[11:8], B[11:8], C2, S[11:8], C3);
    cla_4bit cla3(A[15:12], B[15:12], C3, S[15:12], C_out);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;
    wire C16;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla1(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule