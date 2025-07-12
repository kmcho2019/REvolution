// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [4:1] G, P;
    wire [3:1] C;

    // Calculate G and P values
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] ^ B[4];

    // Calculate C values
    assign C[1] = G[1] | (P[1] & C_in);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C_out = G[4] | (P[4] & C[3]);

    // Calculate S values
    assign S[1] = P[1] ^ C_in;
    assign S[2] = P[2] ^ C[1];
    assign S[3] = P[3] ^ C[2];
    assign S[4] = P[4] ^ C[3];

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

// Hybrid Adder Architecture
module hybrid_adder(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [16:1] S_low;
    wire C16;

    // Ripple-Carry Adder for lower 16 bits
    for (genvar i = 1; i <= 16; i++) begin
        assign S_low[i] = A[i] ^ B[i] ^ C_low[i-1];
        assign C_low[i] = (A[i] & B[i]) | (A[i] & C_low[i-1]) | (B[i] & C_low[i-1]);
    end

    // 16-bit CLA block for upper 16 bits
    cla_16bit u2(
       .A(A[32:17]),
       .B(B[32:17]),
       .C_in(C16),
       .S(S[32:17]),
       .C_out(C32)
    );

    assign S[16:1] = S_low;

endmodule