// 4-bit CLA block
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C0,
    output [4:1] S,
    output C4
);

    wire [4:1] G, P;
    wire [3:1] C;

    // Calculate generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];

    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];

    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];

    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] ^ B[4];

    // Calculate carry (C) signals
    assign C[1] = G[1] | (P[1] & C0);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // Calculate sum (S) signals
    assign S[1] = P[1] ^ C0;
    assign S[2] = P[2] ^ C[1];
    assign S[3] = P[3] ^ C[2];
    assign S[4] = P[4] ^ C[3];

    // Calculate final carry output
    assign C4 = G[4] | (P[4] & C[3]);

endmodule

// 16-bit CLA block
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C0,
    output [16:1] S,
    output C16
);

    wire [8:1] S1, S2;
    wire C8, C9;

    // Instance of 8-bit CLA block for lower 8 bits
    cla_4bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C0(C0),
        .S(S1),
        .C4(C8)
    );

    // Instance of 8-bit CLA block for upper 8 bits
    cla_4bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C0(C8),
        .S(S2),
        .C4(C9)
    );

    // Concatenate sum signals
    assign S[8:1] = S1;
    assign S[16:9] = S2;

    // Calculate final carry output
    assign C16 = C9;

endmodule

// 32-bit CLA adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [16:1] S1, S2;
    wire C16;

    // Instance of 16-bit CLA block for lower 16 bits
    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C0(1'b0),
        .S(S1),
        .C16(C16)
    );

    // Instance of 16-bit CLA block for upper 16 bits
    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C0(C16),
        .S(S2),
        .C16(C32)
    );

    // Concatenate sum signals
    assign S[16:1] = S1;
    assign S[32:17] = S2;

endmodule