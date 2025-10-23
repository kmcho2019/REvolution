// 4-bit carry-lookahead adder block
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:1] G;  // Generate signals
    wire [3:1] P;  // Propagate signals
    wire [2:1] C;  // Internal carries

    // Calculate generate and propagate signals
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];
    assign P[1] = A[1] | B[1];
    assign P[2] = A[2] | B[2];
    assign P[3] = A[3] | B[3];

    // Calculate internal carries
    assign C[1] = G[1] | (P[1] & Cin);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // Calculate sum outputs
    assign S[1] = A[1] ^ B[1] ^ Cin;
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];

    // Calculate final carry-out
    assign Cout = G[3] | (P[3] & C[2]);
    assign S[0] = A[0] ^ B[0] ^ Cin;
endmodule

// 16-bit carry-lookahead adder block
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire C1, C2, C3, C4;  // Internal carries

    cla_4bit u1(A[3:0], B[3:0], Cin, S[3:0], C1);
    cla_4bit u2(A[7:4], B[7:4], C1, S[7:4], C2);
    cla_4bit u3(A[11:8], B[11:8], C2, S[11:8], C3);
    cla_4bit u4(A[15:12], B[15:12], C3, S[15:12], Cout);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;

    wire C16;  // Internal carry

    cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit u2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule