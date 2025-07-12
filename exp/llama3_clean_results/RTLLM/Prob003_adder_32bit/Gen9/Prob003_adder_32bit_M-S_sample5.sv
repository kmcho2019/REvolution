// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [16:1] G, P;

    // Calculate G and P values
    for (genvar i = 1; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate S values and C_out
    assign S[1] = P[1] ^ C_in;
    assign C_out = G[16] + (P[16] & (G[15] + (P[15] & (G[14] + (P[14] & (G[13] + (P[13] & (G[12] + (P[12] & (G[11] + (P[11] & (G[10] + (P[10] & (G[9] + (P[9] & (G[8] + (P[8] & (G[7] + (P[7] & (G[6] + (P[6] & (G[5] + (P[5] & (G[4] + (P[4] & (G[3] + (P[3] & (G[2] + (P[2] & (G[1] + (P[1] & C_in))))))))))))))))))))))));
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = P[i] ^ (G[i-1] + (P[i-1] & (G[i-2] + (P[i-2] & (G[i-3] + (P[i-3] & (G[i-4] + (P[i-4] & (G[i-5] + (P[i-5] & (G[i-6] + (P[i-6] & (G[i-7] + (P[i-7] & (G[i-8] + (P[i-8] & (G[i-9] + (P[i-9] & (G[i-10] + (P[i-10] & (G[i-11] + (P[i-11] & (G[i-12] + (P[i-12] & (G[i-13] + (P[i-13] & (G[i-14] + (P[i-14] & (G[i-15] + (P[i-15] & C_in))))))))))))))))))))))));
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

    // 16-bit CLA block for lower 16 bits
    cla_16bit u1(
      .A(A[16:1]),
      .B(B[16:1]),
      .C_in(1'b0),
      .S(S[16:1]),
      .C_out(C16)
    );

    // 16-bit CLA block for upper 16 bits
    cla_16bit u2(
      .A(A[32:17]),
      .B(B[32:17]),
      .C_in(C16),
      .S(S[32:17]),
      .C_out(C32)
    );

endmodule