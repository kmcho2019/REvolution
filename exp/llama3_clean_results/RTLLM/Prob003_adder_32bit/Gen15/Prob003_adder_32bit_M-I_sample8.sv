// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    // Directly compute carry and sum bits
    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign C_out = (A[16] & B[16]) | ((A[16] ^ B[16]) & (A[15] & B[15]) | (A[15] & B[14]) | (A[14] & B[15]));
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ ((A[i-1] & B[i-1]) | ((A[i-1] ^ B[i-1]) & (A[i-2] & B[i-2]) | (A[i-2] & B[i-3]) | (A[i-3] & B[i-2])));
    end

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    // Instantiate two 16-bit adder blocks
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