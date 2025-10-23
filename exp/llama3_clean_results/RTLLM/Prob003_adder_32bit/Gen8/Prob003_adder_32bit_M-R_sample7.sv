// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);
    reg [16:1] S_reg;
    reg C_out_reg;
    reg [15:1] C;

    integer i;
    always @(*) begin
        C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
        for (i = 2; i <= 15; i++) begin
            C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
        end
        C_out_reg = A[16] & B[16] | (A[16] ^ B[16]) & C[15];

        S_reg[1] = A[1] ^ B[1] ^ C_in;
        for (i = 2; i <= 16; i++) begin
            S_reg[i] = A[i] ^ B[i] ^ C[i-1];
        end
    end

    assign S = S_reg;
    assign C_out = C_out_reg;

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