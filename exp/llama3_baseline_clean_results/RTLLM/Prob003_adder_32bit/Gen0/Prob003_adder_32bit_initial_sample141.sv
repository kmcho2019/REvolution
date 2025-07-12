// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input  cin,
    output [3:0] S,
    output cout
);

    wire [3:0] g, p;
    wire [2:0] c;

    // Calculate generate and propagate signals
    assign g[0] = A[0] & B[0];
    assign p[0] = A[0] | B[0];
    assign g[1] = A[1] & B[1];
    assign p[1] = A[1] | B[1];
    assign g[2] = A[2] & B[2];
    assign p[2] = A[2] | B[2];
    assign g[3] = A[3] & B[3];
    assign p[3] = A[3] | B[3];

    // Calculate internal carries
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);

    // Calculate sum and final carry
    assign S[0] = A[0] ^ B[0] ^ cin;
    assign S[1] = A[1] ^ B[1] ^ c[0];
    assign S[2] = A[2] ^ B[2] ^ c[1];
    assign S[3] = A[3] ^ B[3] ^ c[2];
    assign cout = g[3] | (p[3] & c[2]);

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input  cin,
    output [15:0] S,
    output cout
);

    wire [3:0] g, p;
    wire [15:0] c;
    wire [3:0] G, P;

    // Split A and B into 4-bit segments
    assign A1 = A[3:0];
    assign A2 = A[7:4];
    assign A3 = A[11:8];
    assign A4 = A[15:12];

    assign B1 = B[3:0];
    assign B2 = B[7:4];
    assign B3 = B[11:8];
    assign B4 = B[15:12];

    // Calculate generate and propagate signals for each segment
    cla_4bit u1(A1, B1, cin, S1, c1);
    cla_4bit u2(A2, B2, c1, S2, c2);
    cla_4bit u3(A3, B3, c2, S3, c3);
    cla_4bit u4(A4, B4, c3, S4, cout);

    // Concatenate sum segments
    assign S[3:0] = S1;
    assign S[7:4] = S2;
    assign S[11:8] = S3;
    assign S[15:12] = S4;

endmodule

// Top-level 32-bit Adder
module adder_32bit(
    input  [31:1] A,
    input  [31:1] B,
    output [31:1] S,
    output C32
);

    wire [15:0] A1, A2;
    wire [15:0] B1, B2;
    wire cout1;

    assign A1 = A[15:1];
    assign A2 = A[31:16];
    assign B1 = B[15:1];
    assign B2 = B[31:16];

    cla_16bit u1(A1, B1, 1'b0, S1, cout1);
    cla_16bit u2(A2, B2, cout1, S2, C32);

    // Concatenate sum segments
    assign S[15:1] = S1;
    assign S[31:16] = S2;

endmodule