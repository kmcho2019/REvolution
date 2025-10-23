// Define a 1-bit full adder
module full_adder(
    input A, B, Cin,
    output S, Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

// Define a 4-bit carry-lookahead adder block
module cla_4bit(
    input [3:0] A, B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] P, G;
    assign P[0] = A[0] ^ B[0];
    assign G[0] = A[0] & B[0];
    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    assign P[2] = A[2] ^ B[2];
    assign G[2] = A[2] & B[2];
    assign P[3] = A[3] ^ B[3];
    assign G[3] = A[3] & B[3];

    wire C1, C2, C3;
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);
    assign Cout = G[3] | (P[3] & C3);

    full_adder fa0(A[0], B[0], Cin, S[0], );
    full_adder fa1(A[1], B[1], C1, S[1], );
    full_adder fa2(A[2], B[2], C2, S[2], );
    full_adder fa3(A[3], B[3], C3, S[3], );
endmodule

// Define a 16-bit carry-lookahead adder block
module cla_16bit(
    input [15:0] A, B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] P, G;
    wire C4, C8, C12;
    assign P[0] = A[0] ^ B[0];
    assign G[0] = A[0] & B[0];
    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    assign P[2] = A[2] ^ B[2];
    assign G[2] = A[2] & B[2];
    assign P[3] = A[3] ^ B[3];
    assign G[3] = A[3] & B[3];

    cla_4bit cla0(A[3:0], B[3:0], Cin, S[3:0], C4);
    cla_4bit cla1(A[7:4], B[7:4], C4, S[7:4], C8);
    cla_4bit cla2(A[11:8], B[11:8], C8, S[11:8], C12);
    cla_4bit cla3(A[15:12], B[15:12], C12, S[15:12], Cout);
endmodule

// Top-level 32-bit adder module
module adder_32bit(
    input [31:1] A, B,
    output [31:1] S,
    output C32
);
    wire C16;
    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla1(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule