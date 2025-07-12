// cla_4bit.v: A 4-bit carry-lookahead adder
module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [2:0] C; // Internal carries

    // Calculate generate and propagate signals
    assign G[0] = A[0] & B[0];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];
    assign P[0] = A[0] | B[0];
    assign P[1] = A[1] | B[1];
    assign P[2] = A[2] | B[2];
    assign P[3] = A[3] | B[3];

    // Calculate internal carries and sum
    assign C[0] = Cin;
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign S[1] = A[1] ^ B[1] ^ C[0];
    assign C[2] = G[1] | (P[1] & C[1]);
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign C[3] = G[2] | (P[2] & C[2]);
    assign S[3] = A[3] ^ B[3] ^ C[2];

    // Final carry out
    assign Cout = G[3] | (P[3] & C[3]);
endmodule

// cla_16bit.v: A 16-bit carry-lookahead adder using 4-bit blocks
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [3:0] C; // Internal carries

    // Divide into four 4-bit blocks
    cla_4bit u0(
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(C[0])
    );

    cla_4bit u1(
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C[0]),
        .S(S[7:4]),
        .Cout(C[1])
    );

    cla_4bit u2(
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C[1]),
        .S(S[11:8]),
        .Cout(C[2])
    );

    cla_4bit u3(
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C[2]),
        .S(S[15:12]),
        .Cout(Cout)
    );
endmodule

// adder_32bit.v: A 32-bit carry-lookahead adder using two 16-bit blocks
module adder_32bit(
    input [31:1] A,
    input [31:1] B,
    output [31:1] S,
    output C32
);
    wire C16;

    cla_16bit u0(
        .A(A[15:1]),
        .B(B[15:1]),
        .Cin(1'b0),
        .S(S[15:1]),
        .Cout(C16)
    );

    cla_16bit u1(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule