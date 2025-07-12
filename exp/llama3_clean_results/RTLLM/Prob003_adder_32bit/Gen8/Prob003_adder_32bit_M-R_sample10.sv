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
    wire [15:1] C;

    always @(*) begin
        S_reg[1] = A[1] ^ B[1] ^ C_in;
        C_out_reg = A[16] & B[16] | (A[16] ^ B[16]) & (A[15] & B[15] | (A[15] ^ B[15]) & (A[14] & B[14] | (A[14] ^ B[14]) & (A[13] & B[13] | (A[13] ^ B[13]) & (A[12] & B[12] | (A[12] ^ B[12]) & (A[11] & B[11] | (A[11] ^ B[11]) & (A[10] & B[10] | (A[10] ^ B[10]) & (A[9] & B[9] | (A[9] ^ B[9]) & (A[8] & B[8] | (A[8] ^ B[8]) & (A[7] & B[7] | (A[7] ^ B[7]) & (A[6] & B[6] | (A[6] ^ B[6]) & (A[5] & B[5] | (A[5] ^ B[5]) & (A[4] & B[4] | (A[4] ^ B[4]) & (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & C_in)))));
        for (int i = 2; i <= 16; i++) begin
            S_reg[i] = A[i] ^ B[i] ^ (A[i-1] & B[i-1] | (A[i-1] ^ B[i-1]) & (A[i-2] & B[i-2] | (A[i-2] ^ B[i-2]) & (A[i-3] & B[i-3] | (A[i-3] ^ B[i-3]) & (A[i-4] & B[i-4] | (A[i-4] ^ B[i-4]) & (A[i-5] & B[i-5] | (A[i-5] ^ B[i-5]) & (A[i-6] & B[i-6] | (A[i-6] ^ B[i-6]) & (A[i-7] & B[i-7] | (A[i-7] ^ B[i-7]) & (A[i-8] & B[i-8] | (A[i-8] ^ B[i-8]) & (A[i-9] & B[i-9] | (A[i-9] ^ B[i-9]) & (A[i-10] & B[i-10] | (A[i-10] ^ B[i-10]) & (A[i-11] & B[i-11] | (A[i-11] ^ B[i-11]) & (A[i-12] & B[i-12] | (A[i-12] ^ B[i-12]) & (A[i-13] & B[i-13] | (A[i-13] ^ B[i-13]) & (A[i-14] & B[i-14] | (A[i-14] ^ B[i-14]) & (A[i-15] & B[i-15] | (A[i-15] ^ B[i-15]) & C_in))))))))) );
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