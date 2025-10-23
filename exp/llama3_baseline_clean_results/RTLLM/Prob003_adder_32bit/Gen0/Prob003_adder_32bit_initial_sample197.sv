// Define the 4-bit carry-lookahead adder module
module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);

    // Calculate generate (G) and propagate (P) signals
    wire [3:0] G;
    wire [3:0] P;
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];

    // Calculate carry-in for each bit position
    wire C1, C2, C3;
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);

    // Calculate sum for each bit position
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;

    // Calculate carry-out
    assign Cout = G[3] | (P[3] & C3);

endmodule

// Define the 16-bit carry-lookahead adder module
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);

    // Split the inputs into 4-bit blocks
    wire [3:0] A1, A2, A3, A4;
    wire [3:0] B1, B2, B3, B4;
    assign A1 = A[3:0];
    assign A2 = A[7:4];
    assign A3 = A[11:8];
    assign A4 = A[15:12];
    assign B1 = B[3:0];
    assign B2 = B[7:4];
    assign B3 = B[11:8];
    assign B4 = B[15:12];

    // Calculate sum and carry-out for each 4-bit block
    wire [3:0] S1, S2, S3, S4;
    wire C1, C2, C3, C4;
    cla_4bit cla1(A1, B1, Cin, S1, C1);
    cla_4bit cla2(A2, B2, C1, S2, C2);
    cla_4bit cla3(A3, B3, C2, S3, C3);
    cla_4bit cla4(A4, B4, C3, S4, C4);

    // Combine the sum and carry-out
    assign S[3:0] = S1;
    assign S[7:4] = S2;
    assign S[11:8] = S3;
    assign S[15:12] = S4;
    assign Cout = C4;

endmodule

// Define the 32-bit carry-lookahead adder module
module adder_32bit(
    input [31:1] A,
    input [31:1] B,
    output [31:1] S,
    output C32
);

    // Split the inputs into 16-bit blocks
    wire [15:0] A1, A2;
    wire [15:0] B1, B2;
    assign A1 = A[15:1];
    assign A2 = A[31:16];
    assign B1 = B[15:1];
    assign B2 = B[31:16];

    // Calculate sum and carry-out for each 16-bit block
    wire [15:0] S1, S2;
    wire C1, C2;
    cla_16bit cla1(A1, B1, 1'b0, S1, C1);
    cla_16bit cla2(A2, B2, C1, S2, C2);

    // Combine the sum and carry-out
    assign S[15:1] = S1;
    assign S[31:16] = S2;
    assign C32 = C2;

endmodule