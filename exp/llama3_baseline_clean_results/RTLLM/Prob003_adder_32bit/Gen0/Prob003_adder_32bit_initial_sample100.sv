// Define a 4-bit CLA block
module cla_4bit(
    A, B, Cin, S, Cout
);
input [3:0] A;
input [3:0] B;
input Cin;
output [3:0] S;
output Cout;

wire [3:0] G, P;
wire C1, C2, C3;

// Calculate generate and propagate signals
assign G[0] = A[0] & B[0];
assign P[0] = A[0] | B[0];
assign G[1] = A[1] & B[1];
assign P[1] = A[1] | B[1];
assign G[2] = A[2] & B[2];
assign P[2] = A[2] | B[2];
assign G[3] = A[3] & B[3];
assign P[3] = A[3] | B[3];

// Calculate carry signals
assign C1 = G[0] | (P[0] & Cin);
assign C2 = G[1] | (P[1] & C1);
assign C3 = G[2] | (P[2] & C2);

// Calculate sum signals
assign S[0] = A[0] ^ B[0] ^ Cin;
assign S[1] = A[1] ^ B[1] ^ C1;
assign S[2] = A[2] ^ B[2] ^ C2;
assign S[3] = A[3] ^ B[3] ^ C3;

// Assign Cout
assign Cout = G[3] | (P[3] & C3);

endmodule

// Define a 16-bit CLA block using four 4-bit CLA blocks
module cla_16bit(
    A, B, Cin, S, Cout
);
input [15:0] A;
input [15:0] B;
input Cin;
output [15:0] S;
output Cout;

wire C4, C8, C12;

// First 4-bit block
cla_4bit cla_4bit_0(
    .A(A[3:0]), 
    .B(B[3:0]), 
    .Cin(Cin), 
    .S(S[3:0]), 
    .Cout(C4)
);

// Second 4-bit block
cla_4bit cla_4bit_1(
    .A(A[7:4]), 
    .B(B[7:4]), 
    .Cin(C4), 
    .S(S[7:4]), 
    .Cout(C8)
);

// Third 4-bit block
cla_4bit cla_4bit_2(
    .A(A[11:8]), 
    .B(B[11:8]), 
    .Cin(C8), 
    .S(S[11:8]), 
    .Cout(C12)
);

// Fourth 4-bit block
cla_4bit cla_4bit_3(
    .A(A[15:12]), 
    .B(B[15:12]), 
    .Cin(C12), 
    .S(S[15:12]), 
    .Cout(Cout)
);

endmodule

// Define the 32-bit adder using two 16-bit CLA blocks
module adder_32bit(
    A, B, S, C32
);
input [31:1] A;
input [31:1] B;
output [31:1] S;
output C32;

wire C16;

// First 16-bit block
cla_16bit cla_16bit_0(
    .A(A[15:1]), 
    .B(B[15:1]), 
    .Cin(1'b0), 
    .S(S[15:1]), 
    .Cout(C16)
);

// Second 16-bit block
cla_16bit cla_16bit_1(
    .A(A[31:16]), 
    .B(B[31:16]), 
    .Cin(C16), 
    .S(S[31:16]), 
    .Cout(C32)
);

endmodule