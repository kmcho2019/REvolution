// 4-bit Carry-Lookahead Adder (CLA)
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] G, P; // Generate and Propagate signals
    wire [2:0] C;    // Internal carry signals

    // Calculate Generate (G) and Propagate (P) signals
    assign G[0] = A[0] & B[0];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];
    assign P[0] = A[0] | B[0];
    assign P[1] = A[1] | B[1];
    assign P[2] = A[2] | B[2];
    assign P[3] = A[3] | B[3];

    // Calculate internal carry signals
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);

    // Calculate Cout
    assign Cout = G[3] | (P[3] & C[2]);

    // Calculate sum bits
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C[0];
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];
endmodule

// 16-bit Carry-Lookahead Adder (CLA)
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [3:0] G, P; // Generate and Propagate signals for each 4-bit block
    wire [3:0] C;    // Internal carry signals between 4-bit blocks
    wire C4, C8, C12; // Carry-out from each 4-bit block

    cla_4bit cla0(A[3:0], B[3:0], Cin, S[3:0], C[0]);
    cla_4bit cla1(A[7:4], B[7:4], C[0], S[7:4], C[1]);
    cla_4bit cla2(A[11:8], B[11:8], C[1], S[11:8], C[2]);
    cla_4bit cla3(A[15:12], B[15:12], C[2], S[15:12], Cout);

endmodule

// 32-bit Carry-Lookahead Adder (CLA)
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16; // Carry-out from the first 16-bit block

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla1(A[31:16], B[31:16], C16, S[31:16], C32);

endmodule