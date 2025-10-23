// Predictive Carry-Lookahead Adder for lower 16 bits
module predictive_cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out,
    output predict_C_out
);

    wire [15:1] C;
    wire [15:1] G, P;

    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign C[1] = G[1] | (P[1] & C_in);

    for (genvar i = 2; i <= 15; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end

    assign C_out = G[16] | (P[16] & C[15]);
    assign predict_C_out = G[15] | (P[15] & C_in); // Simplified prediction

    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

endmodule

// Speculative Adder for upper 16 bits
module speculative_adder_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S
);

    wire [16:1] S_with_C0, S_with_C1;

    // Compute sums assuming C_in = 0 and C_in = 1
    for (genvar i = 1; i <= 16; i++) begin
        assign S_with_C0[i] = A[i] ^ B[i];
        assign S_with_C1[i] = A[i] ^ B[i] ^ 1;
    end

    // Select sum based on actual C_in
    for (genvar i = 1; i <= 16; i++) begin
        assign S[i] = C_in ? S_with_C1[i] : S_with_C0[i];
    end

endmodule

// 32-bit Hybrid Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16, predict_C16;
    wire [16:1] S_upper_with_C0, S_upper_with_C1;

    predictive_cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16),
        .predict_C_out(predict_C16)
    );

    // Speculative adder for upper 16 bits
    for (genvar i = 1; i <= 16; i++) begin
        assign S_upper_with_C0[i] = A[i+16] ^ B[i+16];
        assign S_upper_with_C1[i] = A[i+16] ^ B[i+16] ^ 1;
    end

    // Select sum based on actual carry from lower 16 bits
    for (genvar i = 1; i <= 16; i++) begin
        assign S[i+16] = C16 ? S_upper_with_C1[i] : S_upper_with_C0[i];
    end

    assign C32 = A[32] & B[32] | (A[32] ^ B[32]) & C16;

endmodule