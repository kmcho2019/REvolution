// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [4:1] G;  // Generate
    wire [4:1] P;  // Propagate
    wire [3:1] C;  // Carry

    // Calculate Generate and Propagate signals
    assign G = A & B;
    assign P = A ^ B;

    // Calculate Carry signals
    assign C[1] = G[1] | (P[1] & C_in);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // Calculate Sum signals
    assign S[1] = P[1] ^ C_in;
    assign S[2] = P[2] ^ C[1];
    assign S[3] = P[3] ^ C[2];
    assign S[4] = P[4] ^ C[3];

    // Calculate final Carry-out
    assign C_out = G[4] | (P[4] & C[3]);

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [7:0] C;  // Carry signals between 4-bit blocks

    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(1'b0),
        .S(S[4:1]),
        .C_out(C[1])
    );

    cla_4bit u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C[1]),
        .S(S[8:5]),
        .C_out(C[2])
    );

    cla_4bit u3(
        .A(A[12:9]),
        .B(B[12:9]),
        .C_in(C[2]),
        .S(S[12:9]),
        .C_out(C[3])
    );

    cla_4bit u4(
        .A(A[16:13]),
        .B(B[16:13]),
        .C_in(C[3]),
        .S(S[16:13]),
        .C_out(C[4])
    );

    cla_4bit u5(
        .A(A[20:17]),
        .B(B[20:17]),
        .C_in(C[4]),
        .S(S[20:17]),
        .C_out(C[5])
    );

    cla_4bit u6(
        .A(A[24:21]),
        .B(B[24:21]),
        .C_in(C[5]),
        .S(S[24:21]),
        .C_out(C[6])
    );

    cla_4bit u7(
        .A(A[28:25]),
        .B(B[28:25]),
        .C_in(C[6]),
        .S(S[28:25]),
        .C_out(C[7])
    );

    cla_4bit u8(
        .A(A[32:29]),
        .B(B[32:29]),
        .C_in(C[7]),
        .S(S[32:29]),
        .C_out(C32)
    );

endmodule