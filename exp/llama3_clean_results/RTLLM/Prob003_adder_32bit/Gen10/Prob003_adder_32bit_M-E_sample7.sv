// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    reg [4:1] S_reg;
    reg C_out_reg;
    reg [3:1] C;

    integer i;
    always @(*) begin
        C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
        for (i = 2; i <= 3; i++) begin
            C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
        end
        C_out_reg = A[4] & B[4] | (A[4] ^ B[4]) & C[3];

        S_reg[1] = A[1] ^ B[1] ^ C_in;
        for (i = 2; i <= 4; i++) begin
            S_reg[i] = A[i] ^ B[i] ^ C[i-1];
        end
    end

    assign S = S_reg;
    assign C_out = C_out_reg;

endmodule

// 8-bit Carry-Select Adder
module csa_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);
    wire [4:1] S0, S1;
    wire C0, C1;

    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S0),
        .C_out(C0)
    );

    cla_4bit u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C0),
        .S(S1),
        .C_out(C1)
    );

    assign S[4:1] = S0;
    assign S[8:5] = S1;
    assign C_out = C1;

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C8, C16, C24;

    csa_8bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S[8:1]),
        .C_out(C8)
    );

    csa_8bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C8),
        .S(S[16:9]),
        .C_out(C16)
    );

    csa_8bit u3(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C16),
        .S(S[24:17]),
        .C_out(C24)
    );

    csa_8bit u4(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C24),
        .S(S[32:25]),
        .C_out(C32)
    );

endmodule