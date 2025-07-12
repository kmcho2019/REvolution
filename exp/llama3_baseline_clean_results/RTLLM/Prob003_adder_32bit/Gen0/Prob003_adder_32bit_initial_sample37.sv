// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C0,
    output [4:1] S,
    output C4
);
    wire [3:1] G, P, C;
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign C[1] = G[1] | (P[1] & C0);

    assign S[1] = P[1] ^ C0;

    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign C[2] = G[2] | (P[2] & C[1]);

    assign S[2] = P[2] ^ C[1];

    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];
    assign C[3] = G[3] | (P[3] & C[2]);

    assign S[3] = P[3] ^ C[2];

    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] ^ B[4];
    assign C4 = G[4] | (P[4] & C[3]);

    assign S[4] = P[4] ^ C[3];

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C0,
    output [16:1] S,
    output C16
);
    wire C4, C8, C12;
    cla_4bit u1(.A(A[4:1]), .B(B[4:1]), .C0(C0), .S(S[4:1]), .C4(C4));
    cla_4bit u2(.A(A[8:5]), .B(B[8:5]), .C0(C4), .S(S[8:5]), .C4(C8));
    cla_4bit u3(.A(A[12:9]), .B(B[12:9]), .C0(C8), .S(S[12:9]), .C4(C12));
    cla_4bit u4(.A(A[16:13]), .B(B[16:13]), .C0(C12), .S(S[16:13]), .C4(C16));

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    cla_16bit u1(.A(A[16:1]), .B(B[16:1]), .C0(1'b0), .S(S[16:1]), .C16(C16));
    cla_16bit u2(.A(A[32:17]), .B(B[32:17]), .C0(C16), .S(S[32:17]), .C16(C32));

endmodule