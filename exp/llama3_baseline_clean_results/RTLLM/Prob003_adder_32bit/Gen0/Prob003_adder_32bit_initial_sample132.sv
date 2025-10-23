// 4-bit Carry-Lookahead Adder module
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] G; // Generate signal
    wire [3:0] P; // Propagate signal
    wire C1, C2, C3; // Internal carries

    // Generate and Propagate signals
    assign G[0] = A[0] & B[0];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];

    assign P[0] = A[0] | B[0];
    assign P[1] = A[1] | B[1];
    assign P[2] = A[2] | B[2];
    assign P[3] = A[3] | B[3];

    // Calculate internal carries
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & (G[0] | (P[0] & Cin)));
    assign C3 = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))));

    // Calculate sum and final carry
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;
    assign Cout = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))));
endmodule

// 16-bit Carry-Lookahead Adder module
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire C4, C8, C12; // Internal carries

    cla_4bit u1(A[3:0], B[3:0], Cin, S[3:0], C4);
    cla_4bit u2(A[7:4], B[7:4], C4, S[7:4], C8);
    cla_4bit u3(A[11:8], B[11:8], C8, S[11:8], C12);
    cla_4bit u4(A[15:12], B[15:12], C12, S[15:12], Cout);
endmodule

// 32-bit Carry-Lookahead Adder module
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;

    wire C16; // Internal carry

    cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit u2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule