// 4-bit Carry-Lookahead Adder module
module cla_4bit(
    input [4:1] A, B,
    input C0,
    output [4:1] S,
    output C4
    );

    // Generate and Propagate signals for each bit position
    wire [4:1] G, P;
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] | B[4];

    // Carry calculation
    wire C1, C2, C3;
    assign C1 = G[1] | (P[1] & C0);
    assign C2 = G[2] | (P[2] & C1);
    assign C3 = G[3] | (P[3] & C2);
    assign C4 = G[4] | (P[4] & C3);

    // Sum calculation
    assign S[1] = A[1] ^ B[1] ^ C0;
    assign S[2] = A[2] ^ B[2] ^ C1;
    assign S[3] = A[3] ^ B[3] ^ C2;
    assign S[4] = A[4] ^ B[4] ^ C3;

endmodule

// 16-bit Carry-Lookahead Adder module
module cla_16bit(
    input [16:1] A, B,
    input C0,
    output [16:1] S,
    output C16
    );

    // Use 4 instances of 4-bit CLA blocks
    wire [4:1] C;
    cla_4bit cla1(A[4:1], B[4:1], C0, S[4:1], C[1]);
    cla_4bit cla2(A[8:5], B[8:5], C[1], S[8:5], C[2]);
    cla_4bit cla3(A[12:9], B[12:9], C[2], S[12:9], C[3]);
    cla_4bit cla4(A[16:13], B[16:13], C[3], S[16:13], C16);

endmodule

// 32-bit Carry-Lookahead Adder module
module adder_32bit(
    input [32:1] A, B,
    output [32:1] S,
    output C32
    );

    // Use 2 instances of 16-bit CLA blocks
    wire C16;
    cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit cla2(A[32:17], B[32:17], C16, S[32:17], C32);

endmodule