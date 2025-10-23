// 4-bit Prefix Tree
module prefix_tree_4bit(
    input [4:1] A,
    input [4:1] B,
    output [4:1] carry
);
    assign carry[1] = A[1] & B[1];
    assign carry[2] = (A[2] & B[2]) | (A[2] ^ B[2]) & carry[1];
    assign carry[3] = (A[3] & B[3]) | (A[3] ^ B[3]) & carry[2];
    assign carry[4] = (A[4] & B[4]) | (A[4] ^ B[4]) & carry[3];

endmodule

// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    wire [4:1] carry;
    prefix_tree_4bit u1(
       .A(A),
       .B(B),
       .carry(carry)
    );

    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign S[2] = A[2] ^ B[2] ^ carry[1];
    assign S[3] = A[3] ^ B[3] ^ carry[2];
    assign S[4] = A[4] ^ B[4] ^ carry[3];
    assign C_out = carry[4];

endmodule

// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);
    wire [4:1] S1, S2;
    wire C1, C2;

    cla_4bit u1(
       .A(A[4:1]),
       .B(B[4:1]),
       .C_in(C_in),
       .S(S1),
       .C_out(C1)
    );

    cla_4bit u2(
       .A(A[8:5]),
       .B(B[8:5]),
       .C_in(C1),
       .S(S2),
       .C_out(C2)
    );

    assign S[4:1] = S1;
    assign S[8:5] = S2;
    assign C_out = C2;

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);
    wire [8:1] S1, S2;
    wire C1, C2;

    cla_8bit u1(
       .A(A[8:1]),
       .B(B[8:1]),
       .C_in(C_in),
       .S(S1),
       .C_out(C1)
    );

    cla_8bit u2(
       .A(A[16:9]),
       .B(B[16:9]),
       .C_in(C1),
       .S(S2),
       .C_out(C2)
    );

    assign S[8:1] = S1;
    assign S[16:9] = S2;
    assign C_out = C2;

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [16:1] S1, S2;
    wire C1, C2;

    cla_16bit u1(
       .A(A[16:1]),
       .B(B[16:1]),
       .C_in(1'b0),
       .S(S1),
       .C_out(C1)
    );

    cla_16bit u2(
       .A(A[32:17]),
       .B(B[32:17]),
       .C_in(C1),
       .S(S2),
       .C_out(C2)
    );

    assign S[16:1] = S1;
    assign S[32:17] = S2;
    assign C32 = C2;

endmodule