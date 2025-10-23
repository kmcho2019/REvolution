// 4-bit CLA module
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire G0, G1, G2, G3;
    wire P0, P1, P2, P3;
    wire C1, C2, C3;

    // Generate and propagate signals
    assign G0 = A[0] & B[0];
    assign G1 = A[1] & B[1];
    assign G2 = A[2] & B[2];
    assign G3 = A[3] & B[3];
    assign P0 = A[0] | B[0];
    assign P1 = A[1] | B[1];
    assign P2 = A[2] | B[2];
    assign P3 = A[3] | B[3];

    // Carry signals
    assign C1 = G0 | (P0 & Cin);
    assign C2 = G1 | (P1 & C1);
    assign C3 = G2 | (P2 & C2);

    // Sum signals
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;

    // Final carry-out
    assign Cout = G3 | (P3 & C3);
endmodule

// 16-bit CLA module using 4-bit CLA blocks
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire C4, C8, C12;

    cla_4bit cla_0(A[3:0], B[3:0], Cin, S[3:0], C4);
    cla_4bit cla_1(A[7:4], B[7:4], C4, S[7:4], C8);
    cla_4bit cla_2(A[11:8], B[11:8], C8, S[11:8], C12);
    cla_4bit cla_3(A[15:12], B[15:12], C12, S[15:12], Cout);
endmodule

// 32-bit CLA module using 16-bit CLA blocks
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;

    wire C16;

    cla_16bit cla_0(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla_1(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule