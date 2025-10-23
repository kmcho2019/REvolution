// 4-bit Carry-Lookahead Adder
module cla_4bit(
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

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [4:1] C;

    for (genvar i = 1; i <= 4; i++) begin
        cla_4bit u1(
          .A(A[(i*4):((i*4)-3)]),
          .B(B[(i*4):((i*4)-3)]),
          .C_in(i == 1? C_in : C[i-1]),
          .S(S[(i*4):((i*4)-3)]),
          .C_out(C[i])
        );
    end

    assign C_out = C[4];

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