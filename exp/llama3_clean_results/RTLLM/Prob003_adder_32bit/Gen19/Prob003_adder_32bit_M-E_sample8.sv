// 8-bit Ripple-Carry Adder
module rca_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [8:1] C;

    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign C[1] = (A[1] & B[1]) | (A[1] & C_in) | (B[1] & C_in);

    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
        assign C[i] = (A[i] & B[i]) | (A[i] & C[i-1]) | (B[i] & C[i-1]);
    end

    assign C_out = C[8];

endmodule

// 8-bit to 8-bit Carry-Lookahead Adder for segment carry propagation
module cla_segment(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [8:1] P, G;
    wire [7:1] C;

    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    for (genvar i = 2; i <= 8; i++) begin
        assign P[i] = A[i] ^ B[i];
        assign G[i] = A[i] & B[i];
    end

    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 7; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign C_out = G[8] | (P[8] & C[7]);

    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// Tree-like Carry Propagation Module
module carry_propagate(
    input [4:1] C_in, // Carry inputs from 4 segments
    output [4:1] C_out // Carry outputs to 4 segments
);

    wire [3:1] C_int;

    assign C_out[1] = C_in[1];
    assign C_int[1] = C_in[1];
    for (genvar i = 2; i <= 3; i++) begin
        assign C_out[i] = C_int[i-1] | C_in[i];
        assign C_int[i] = C_out[i];
    end
    assign C_out[4] = C_int[3] | C_in[4];

endmodule

// 32-bit Hybrid Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [8:1] S1, S2, S3, S4;
    wire C1, C2, C3, C4, C5, C6, C7, C8;
    wire [4:1] carry_tree_in, carry_tree_out;

    rca_8bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S1),
        .C_out(C1)
    );

    rca_8bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C1),
        .S(S2),
        .C_out(C2)
    );

    rca_8bit u3(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C2),
        .S(S3),
        .C_out(C3)
    );

    rca_8bit u4(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C3),
        .S(S4),
        .C_out(C4)
    );

    assign carry_tree_in[1] = C1;
    assign carry_tree_in[2] = C2;
    assign carry_tree_in[3] = C3;
    assign carry_tree_in[4] = C4;

    carry_propagate u5(
        .C_in(carry_tree_in),
        .C_out(carry_tree_out)
    );

    assign C5 = carry_tree_out[1];
    assign C6 = carry_tree_out[2];
    assign C7 = carry_tree_out[3];
    assign C8 = carry_tree_out[4];

    cla_segment u6(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(C5),
        .S(S1),
        .C_out(C1)
    );

    cla_segment u7(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C6),
        .S(S2),
        .C_out(C2)
    );

    cla_segment u8(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C7),
        .S(S3),
        .C_out(C3)
    );

    cla_segment u9(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C8),
        .S(S4),
        .C_out(C32)
    );

    assign S[8:1] = S1;
    assign S[16:9] = S2;
    assign S[24:17] = S3;
    assign S[32:25] = S4;

endmodule