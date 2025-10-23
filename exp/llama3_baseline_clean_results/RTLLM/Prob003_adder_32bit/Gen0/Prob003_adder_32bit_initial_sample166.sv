// 4-bit carry-lookahead adder
module cla_4bit(A, B, C_in, S, C_out);
    input [4:1] A, B;
    input C_in;
    output [4:1] S;
    output C_out;

    wire [4:1] P, G;
    wire C1, C2, C3, C4;

    // Calculate propagate and generate signals
    assign P[1] = A[1] ^ B[1];
    assign P[2] = A[2] ^ B[2];
    assign P[3] = A[3] ^ B[3];
    assign P[4] = A[4] ^ B[4];

    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];
    assign G[4] = A[4] & B[4];

    // Calculate carry signals
    assign C1 = G[1] | (P[1] & C_in);
    assign C2 = G[2] | (P[2] & (G[1] | (P[1] & C_in)));
    assign C3 = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & C_in)))));
    assign C4 = G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & C_in)))))));

    // Calculate sum signals
    assign S[1] = P[1] ^ C_in;
    assign S[2] = P[2] ^ (G[1] | (P[1] & C_in));
    assign S[3] = P[3] ^ (G[2] | (P[2] & (G[1] | (P[1] & C_in))));
    assign S[4] = P[4] ^ (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & C_in))))));

    assign C_out = C4;

endmodule

// 16-bit carry-lookahead adder
module cla_16bit(A, B, C_in, S, C_out);
    input [16:1] A, B;
    input C_in;
    output [16:1] S;
    output C_out;

    wire C4, C8, C12;

    cla_4bit u1(A[4:1], B[4:1], C_in, S[4:1], C4);
    cla_4bit u2(A[8:5], B[8:5], C4, S[8:5], C8);
    cla_4bit u3(A[12:9], B[12:9], C8, S[12:9], C12);
    cla_4bit u4(A[16:13], B[16:13], C12, S[16:13], C_out);

endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire C16;

    cla_16bit u1(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit u2(A[32:17], B[32:17], C16, S[32:17], C32);

endmodule