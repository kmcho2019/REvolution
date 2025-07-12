// 4-bit CLA block
module cla_4bit(
    A, B, Cin, S, Cout
);
input [4:1] A, B;
input Cin;
output [4:1] S;
output Cout;

wire [4:1] G, P;
wire [3:1] C;

// Generate and Propagate signals
assign G[1] = A[1] & B[1];
assign P[1] = A[1] | B[1];
assign G[2] = A[2] & B[2];
assign P[2] = A[2] | B[2];
assign G[3] = A[3] & B[3];
assign P[3] = A[3] | B[3];
assign G[4] = A[4] & B[4];
assign P[4] = A[4] | B[4];

// Carry calculation
assign C[1] = G[1] | (P[1] & Cin);
assign C[2] = G[2] | (P[2] & C[1]);
assign C[3] = G[3] | (P[3] & C[2]);
assign Cout = G[4] | (P[4] & C[3]);

// Sum calculation
assign S[1] = A[1] ^ B[1] ^ Cin;
assign S[2] = A[2] ^ B[2] ^ C[1];
assign S[3] = A[3] ^ B[3] ^ C[2];
assign S[4] = A[4] ^ B[4] ^ C[3];

endmodule

// 16-bit CLA block
module cla_16bit(
    A, B, Cin, S, Cout
);
input [16:1] A, B;
input Cin;
output [16:1] S;
output Cout;

wire Cout1, Cout2, Cout3, Cout4;

cla_4bit cla1(A[4:1], B[4:1], Cin, S[4:1], Cout1);
cla_4bit cla2(A[8:5], B[8:5], Cout1, S[8:5], Cout2);
cla_4bit cla3(A[12:9], B[12:9], Cout2, S[12:9], Cout3);
cla_4bit cla4(A[16:13], B[16:13], Cout3, S[16:13], Cout4);

assign Cout = Cout4;

endmodule

// 32-bit CLA block
module adder_32bit(
    A, B, S, C32
);
input [32:1] A, B;
output [32:1] S;
output C32;

wire Cout1;

cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], Cout1);
cla_16bit cla2(A[32:17], B[32:17], Cout1, S[32:17], C32);

endmodule