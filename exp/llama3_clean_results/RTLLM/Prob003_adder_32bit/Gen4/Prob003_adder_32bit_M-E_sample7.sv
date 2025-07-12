// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [4:1] G, P;
    wire [3:1] C;

    for (genvar i = 1; i <= 4; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    assign C[1] = G[1] + (P[1] & C_in);
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = G[i] + (P[i] & C[i-1]);
    end
    assign C_out = G[4] + (P[4] & C[3]);

    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 4; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [8:1] G, P;
    wire [7:1] C;

    for (genvar i = 1; i <= 8; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    assign C[1] = G[1] + (P[1] & C_in);
    for (genvar i = 2; i <= 7; i++) begin
        assign C[i] = G[i] + (P[i] & C[i-1]);
    end
    assign C_out = G[8] + (P[8] & C[7]);

    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// Hierarchical Bit-Slice Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [8:1] S1, S2, S3, S4, S5, S6, S7, S8;
    wire C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16;

    // 4-bit adders
    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(1'b0),
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

    cla_4bit u3(
        .A(A[12:9]),
        .B(B[12:9]),
        .C_in(C2),
        .S(S3),
        .C_out(C3)
    );

    cla_4bit u4(
        .A(A[16:13]),
        .B(B[16:13]),
        .C_in(C3),
        .S(S4),
        .C_out(C4)
    );

    cla_4bit u5(
        .A(A[20:17]),
        .B(B[20:17]),
        .C_in(C4),
        .S(S5),
        .C_out(C5)
    );

    cla_4bit u6(
        .A(A[24:21]),
        .B(B[24:21]),
        .C_in(C5),
        .S(S6),
        .C_out(C6)
    );

    cla_4bit u7(
        .A(A[28:25]),
        .B(B[28:25]),
        .C_in(C6),
        .S(S7),
        .C_out(C7)
    );

    cla_4bit u8(
        .A(A[32:29]),
        .B(B[32:29]),
        .C_in(C7),
        .S(S8),
        .C_out(C8)
    );

    // 8-bit adders
    cla_8bit u9(
        .A({A[8:5], A[4:1]}),
        .B({B[8:5], B[4:1]}),
        .C_in(1'b0),
        .S({S2, S1}),
        .C_out(C9)
    );

    cla_8bit u10(
        .A({A[16:13], A[12:9]}),
        .B({B[16:13], B[12:9]}),
        .C_in(C9),
        .S({S4, S3}),
        .C_out(C10)
    );

    cla_8bit u11(
        .A({A[24:21], A[20:17]}),
        .B({B[24:21], B[20:17]}),
        .C_in(C10),
        .S({S6, S5}),
        .C_out(C11)
    );

    cla_8bit u12(
        .A({A[32:29], A[28:25]}),
        .B({B[32:29], B[28:25]}),
        .C_in(C11),
        .S({S8, S7}),
        .C_out(C12)
    );

    // Final 32-bit adder
    assign S[4:1] = S1;
    assign S[8:5] = S2;
    assign S[12:9] = S3;
    assign S[16:13] = S4;
    assign S[20:17] = S5;
    assign S[24:21] = S6;
    assign S[28:25] = S7;
    assign S[32:29] = S8;
    assign C32 = C12;

endmodule