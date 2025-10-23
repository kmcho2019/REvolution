// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [15:1] C;

    assign C[1] = A[1] & B[1] | (A[1] ^ B[1]) & Cin;
    for (genvar i = 2; i <= 15; i++) begin
        assign C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
    end
    assign Cout = A[16] & B[16] | (A[16] ^ B[16]) & C[15];

    assign S[1] = A[1] ^ B[1] ^ Cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
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
       .Cin(1'b0),
       .S(S[16:1]),
       .Cout(C16)
    );

    cla_16bit u2(
       .A(A[32:17]),
       .B(B[32:17]),
       .Cin(C16),
       .S(S[32:17]),
       .Cout(C32)
    );

endmodule