// 4-bit Ripple-Carry Adder
module rca_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [3:1] C;

    assign C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
    end
    assign C_out = A[4] & B[4] | (A[4] ^ B[4]) & C[3];

    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 2; i <= 4; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

endmodule

// Carry-Lookahead Logic
module cla_logic(
    input [4:1] A,
    input [4:1] B,
    output [4:1] P,
    output [4:1] G
);

    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    for (genvar i = 2; i <= 4; i++) begin
        assign P[i] = A[i] ^ B[i];
        assign G[i] = A[i] & B[i];
    end

endmodule

// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [4:1] P, G;
    wire [3:1] C;

    cla_logic u1(
       .A(A),
       .B(B),
       .P(P),
       .G(G)
    );

    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign C_out = G[4] | (P[4] & C[3]);

    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 4; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [4:1] S1, S2, S3, S4, S5, S6, S7, S8;
    wire C1, C2, C3, C4, C5, C6, C7;

    // Replace the first 4-bit ripple-carry adder with a carry-lookahead adder
    cla_4bit u1(
       .A(A[4:1]),
       .B(B[4:1]),
       .C_in(1'b0),
       .S(S1),
       .C_out(C1)
    );

    // Instantiate the remaining 4-bit adder blocks using a loop
    for (genvar i = 2; i <= 8; i++) begin
        cla_4bit u_(
           .A(A[(i*4):((i-1)*4+1)]),
           .B(B[(i*4):((i-1)*4+1)]),
           .C_in(i == 2? C1 : (i == 3? C2 : (i == 4? C3 : (i == 5? C4 : (i == 6? C5 : (i == 7? C6 : C7)))))),
           .S(i == 2? S2 : (i == 3? S3 : (i == 4? S4 : (i == 5? S5 : (i == 6? S6 : (i == 7? S7 : S8)))))),
           .C_out(i == 2? C2 : (i == 3? C3 : (i == 4? C4 : (i == 5? C5 : (i == 6? C6 : (i == 7? C7 : C32))))))
        );
    end

    assign S[4:1] = S1;
    assign S[8:5] = S2;
    assign S[12:9] = S3;
    assign S[16:13] = S4;
    assign S[20:17] = S5;
    assign S[24:21] = S6;
    assign S[28:25] = S7;
    assign S[32:29] = S8;

endmodule