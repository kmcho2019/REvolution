// 4-bit Carry-Lookahead Adder with optimized internal logic
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [4:1] G;  // Generate
    wire [4:1] P;  // Propagate
    wire [3:1] C;  // Carry

    assign G = A & B;
    assign P = A ^ B;

    // Optimized carry calculation
    assign C[1] = G[1] | (P[1] & C_in);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    assign S[1] = P[1] ^ C_in;
    assign S[2] = P[2] ^ C[1];
    assign S[3] = P[3] ^ C[2];
    assign S[4] = A[4] ^ B[4] ^ C[3];

    assign C_out = G[4] | (P[4] & C[3]);

endmodule

// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire C4;

    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S[4:1]),
        .C_out(C4)
    );

    cla_4bit u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C4),
        .S(S[8:5]),
        .C_out(C_out)
    );

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [16:1] G, P;
    wire [15:1] C;

    // Calculate G and P values
    for (genvar i = 1; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate C values
    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 15; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign C_out = G[16] | (P[16] & C[15]);

    // Calculate S values
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 16; i++) begin
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