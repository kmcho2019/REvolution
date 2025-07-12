// Parameterized 16-bit Carry-Lookahead Adder
module cla(
    parameter WIDTH = 16,
    input [WIDTH:1] A,
    input [WIDTH:1] B,
    input C_in,
    output [WIDTH:1] S,
    output C_out
);

    wire [WIDTH:1] G, P;
    wire [WIDTH-1:1] C;

    // Calculate G and P values
    for (genvar i = 1; i <= WIDTH; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate C values
    assign C[1] = G[1] + (P[1] & C_in);
    for (genvar i = 2; i < WIDTH; i++) begin
        assign C[i] = G[i] + (P[i] & C[i-1]);
    end
    assign C_out = G[WIDTH] + (P[WIDTH] & C[WIDTH-1]);

    // Calculate S values
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= WIDTH; i++) begin
        assign S[i] = P[i] ^ C[i-1];
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
    cla #(.WIDTH(16)) u1(
      .A(A[16:1]),
      .B(B[16:1]),
      .C_in(1'b0),
      .S(S[16:1]),
      .C_out(C16)
    );

    // 16-bit CLA block for upper 16 bits
    cla #(.WIDTH(16)) u2(
      .A(A[32:17]),
      .B(B[32:17]),
      .C_in(C16),
      .S(S[32:17]),
      .C_out(C32)
    );

endmodule