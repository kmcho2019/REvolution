// 4-bit carry-lookahead adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    output [4:1] S,
    output C_out,
    output G,  // Generate signal
    output P   // Propagate signal
);

    // Calculate the generate and propagate signals for each bit
    wire g1, g2, g3, g4, p1, p2, p3, p4;
    assign g1 = A[1] & B[1];
    assign g2 = A[2] & B[2];
    assign g3 = A[3] & B[3];
    assign g4 = A[4] & B[4];
    assign p1 = A[1] | B[1];
    assign p2 = A[2] | B[2];
    assign p3 = A[3] | B[3];
    assign p4 = A[4] | B[4];

    // Calculate the generate signal for the 4-bit block
    assign G = g4 | (g3 & p4) | (g2 & p3 & p4) | (g1 & p2 & p3 & p4);

    // Calculate the propagate signal for the 4-bit block
    assign P = p1 & p2 & p3 & p4;

    // Calculate the sum for each bit
    assign S[1] = A[1] ^ B[1];
    assign S[2] = A[2] ^ B[2];
    assign S[3] = A[3] ^ B[3];
    assign S[4] = A[4] ^ B[4];

    // Calculate the carry-out
    assign C_out = g4 | (g3 & p4) | (g2 & p3 & p4) | (g1 & p2 & p3 & p4);

endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    output [16:1] S,
    output C_out
);

    // Declare wires for the generate and propagate signals
    wire g1, g2, g3, g4, p1, p2, p3, p4;
    wire c1, c2, c3;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla1(
        .A(A[4:1]),
        .B(B[4:1]),
        .S(S[4:1]),
        .C_out(c1),
        .G(g1),
        .P(p1)
    );

    cla_4bit cla2(
        .A(A[8:5]),
        .B(B[8:5]),
        .S(S[8:5]),
        .C_out(c2),
        .G(g2),
        .P(p2)
    );

    cla_4bit cla3(
        .A(A[12:9]),
        .B(B[12:9]),
        .S(S[12:9]),
        .C_out(c3),
        .G(g3),
        .P(p3)
    );

    cla_4bit cla4(
        .A(A[16:13]),
        .B(B[16:13]),
        .S(S[16:13]),
        .C_out(C_out),
        .G(g4),
        .P(p4)
    );

    // Calculate the carry-in for each block
    assign S[5] = A[5] ^ B[5] ^ c1;
    assign S[9] = A[9] ^ B[9] ^ c2;
    assign S[13] = A[13] ^ B[13] ^ c3;

endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    // Declare wires for the carry-out
    wire c16;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla1(
        .A(A[16:1]),
        .B(B[16:1]),
        .S(S[16:1]),
        .C_out(c16)
    );

    cla_16bit cla2(
        .A(A[32:17]),
        .B(B[32:17]),
        .S(S[32:17]),
        .C_out(C32)
    );

    // Assign the carry-in for the second block
    assign S[17] = A[17] ^ B[17] ^ c16;

endmodule