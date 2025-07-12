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

    // Calculate G and P values using a for-loop for simplicity and efficiency
    for (genvar i = 1; i <= 16; i++) begin
        assign G[i] = A[i] & B[i]; // Explicitly calculate G signal for clarity
        assign P[i] = A[i] ^ B[i]; // Explicitly calculate P signal for clarity
    end

    // Calculate C values, propagating the carry
    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 15; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign C_out = G[16] | (P[16] & C[15]);

    // Calculate S values based on P and C
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

    // Instantiate the first 16-bit CLA block for the lower 16 bits
    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    // Instantiate the second 16-bit CLA block for the upper 16 bits
    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule