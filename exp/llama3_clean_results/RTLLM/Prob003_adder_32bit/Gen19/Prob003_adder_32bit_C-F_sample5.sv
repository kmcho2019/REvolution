// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [15:0] C;

    assign C[0] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
    for (genvar i = 1; i < 15; i++) begin
        assign C[i] = A[i+1] & B[i+1] | (A[i+1] ^ B[i+1]) & C[i-1];
    end
    assign C_out = A[16] & B[16] | (A[16] ^ B[16]) & C[14];

    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 1; i < 16; i++) begin
        assign S[i+1] = A[i+1] ^ B[i+1] ^ C[i-1];
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
       .C_out(C32)
    );

    assign S[32:17] = u2.S;

endmodule