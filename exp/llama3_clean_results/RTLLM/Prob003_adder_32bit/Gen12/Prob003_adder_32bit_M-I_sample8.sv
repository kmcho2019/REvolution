// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);
    wire [15:1] C;
    wire [15:1] G, P;

    // Compute generate and propagate bits
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Compute carry bits
    assign C[1] = G[1] | (P[1] & C_in);
    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Compute sum bits
    assign S[1] = A[1] ^ B[1] ^ C_in;
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate

    // Compute carry-out
    assign C_out = G[16] | (P[16] & C[15]);

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