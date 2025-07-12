// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [15:0] G, P;
    wire [15:1] C;

    for (genvar i = 1; i <= 16; i++) begin
        assign G[i-1] = A[i] & B[i];
        assign P[i-1] = A[i] ^ B[i];
    end

    assign C[1] = G[0] | (P[0] & C_in);
    for (genvar i = 2; i <= 16; i++) begin
        assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
    end

    assign S[1] = P[0] ^ C_in;
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = P[i-1] ^ C[i-1];
    end

    assign C_out = G[15] | (P[15] & C[15]);

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule