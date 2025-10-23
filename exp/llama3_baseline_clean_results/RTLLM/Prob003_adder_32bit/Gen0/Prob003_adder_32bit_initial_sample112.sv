// Define the 4-bit CLA module
module cla_4bit(A, B, Cin, S, Cout, G, P);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;
    output [3:0] G;
    output [3:0] P;

    wire [3:0] G_int, P_int;

    // Calculate generate and propagate signals
    assign G_int[0] = A[0] & B[0];
    assign P_int[0] = A[0] | B[0];
    assign G_int[1] = A[1] & B[1];
    assign P_int[1] = A[1] | B[1];
    assign G_int[2] = A[2] & B[2];
    assign P_int[2] = A[2] | B[2];
    assign G_int[3] = A[3] & B[3];
    assign P_int[3] = A[3] | B[3];

    // Calculate sum and carry-out
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ (P_int[0] & Cin);
    assign S[2] = A[2] ^ B[2] ^ (P_int[1] & P_int[0] & Cin);
    assign S[3] = A[3] ^ B[3] ^ (P_int[2] & P_int[1] & P_int[0] & Cin);
    assign Cout = (G_int[3] | (P_int[3] & (G_int[2] | (P_int[2] & (G_int[1] | (P_int[1] & (G_int[0] | (P_int[0] & Cin)))))));

    assign G = G_int;
    assign P = P_int;
endmodule

// Define the 16-bit CLA module using four 4-bit CLAs
module cla_16bit(A, B, Cin, S, Cout, G, P);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;
    output [15:0] G;
    output [15:0] P;

    wire C4, C8, C12;

    cla_4bit cla0(A[3:0], B[3:0], Cin, S[3:0], C4, G[3:0], P[3:0]);
    cla_4bit cla1(A[7:4], B[7:4], C4, S[7:4], C8, G[7:4], P[7:4]);
    cla_4bit cla2(A[11:8], B[11:8], C8, S[11:8], C12, G[11:8], P[11:8]);
    cla_4bit cla3(A[15:12], B[15:12], C12, S[15:12], Cout, G[15:12], P[15:12]);

endmodule

// Define the 32-bit CLA module using two 16-bit CLAs
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], C16, , );
    cla_16bit cla1(A[31:16], B[31:16], C16, S[31:16], C32, , );

endmodule