// 8-bit Arithmetic Logic Unit (ALU)
module alu_8bit(
    input [7:0] A,
    input [7:0] B,
    input C_in,
    output [7:0] S,
    output C_out
);

    assign S[0] = A[0] ^ B[0] ^ C_in;
    assign S[1] = A[1] ^ B[1] ^ (A[0] & B[0] | (A[0] ^ B[0]) & C_in);
    assign S[2] = A[2] ^ B[2] ^ (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in));
    assign S[3] = A[3] ^ B[3] ^ (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in)));
    assign S[4] = A[4] ^ B[4] ^ (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in))));
    assign S[5] = A[5] ^ B[5] ^ (A[4] & B[4] | (A[4] ^ B[4]) & (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in)))));
    assign S[6] = A[6] ^ B[6] ^ (A[5] & B[5] | (A[5] ^ B[5]) & (A[4] & B[4] | (A[4] ^ B[4]) & (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in))))))
    ;
    assign S[7] = A[7] ^ B[7] ^ (A[6] & B[6] | (A[6] ^ B[6]) & (A[5] & B[5] | (A[5] ^ B[5]) & (A[4] & B[4] | (A[4] ^ B[4]) & (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in)))))));
    assign C_out = (A[7] & B[7]) | (A[7] ^ B[7]) & (A[6] & B[6] | (A[6] ^ B[6]) & (A[5] & B[5] | (A[5] ^ B[5]) & (A[4] & B[4] | (A[4] ^ B[4]) & (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in)))))));

endmodule

// 8-bit Carry-Lookahead Generator
module cla_8bit_gen(
    input [7:0] A,
    input [7:0] B,
    output C_out
);

    assign C_out = (A[7] & B[7]) | (A[7] ^ B[7]) & (A[6] & B[6] | (A[6] ^ B[6]) & (A[5] & B[5] | (A[5] ^ B[5]) & (A[4] & B[4] | (A[4] ^ B[4]) & (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]))))))));

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

    wire C8, C16, C24;

    alu_8bit u1(
       .A(A[7:0]),
       .B(B[7:0]),
       .C_in(1'b0),
       .S(S[7:0]),
       .C_out(C8)
    );

    cla_8bit_gen g1(
       .A(A[15:8]),
       .B(B[15:8]),
       .C_out(C16)
    );

    alu_8bit u2(
       .A(A[15:8]),
       .B(B[15:8]),
       .C_in(C8),
       .S(S[15:8]),
       .C_out(C16)
    );

    cla_8bit_gen g2(
       .A(A[23:16]),
       .B(B[23:16]),
       .C_out(C24)
    );

    alu_8bit u3(
       .A(A[23:16]),
       .B(B[23:16]),
       .C_in(C16),
       .S(S[23:16]),
       .C_out(C24)
    );

    alu_8bit u4(
       .A(A[31:24]),
       .B(B[31:24]),
       .C_in(C24),
       .S(S[31:24]),
       .C_out(C32)
    );

endmodule