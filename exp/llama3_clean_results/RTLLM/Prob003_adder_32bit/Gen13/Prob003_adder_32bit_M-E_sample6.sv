// 8-bit Carry-Lookahead Adder with Predictive Carry
module cla_8bit_predictive(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [8:1] G, P;
    wire [7:1] C;

    // Shared-resource block for calculating G and P
    for (genvar i = 1; i <= 8; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Predictive carry calculation
    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 7; i++) begin
        assign C[i] = G[i] | (P[i] & (C[i-1] | (P[i-1] & G[i-1])));
    end
    assign C_out = G[8] | (P[8] & (C[7] | (P[7] & G[7])));

    // Calculate S values using predictive carry
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = P[i] ^ (C[i-1] | (P[i-1] & G[i-1]));
    end

endmodule

// 32-bit Hybrid Carry-Lookahead Adder
module adder_32bit_hybrid(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C8, C16, C24;

    // Instantiation of 8-bit CLA blocks with predictive carry
    cla_8bit_predictive lowerCLA(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S[8:1]),
        .C_out(C8)
    );

    cla_8bit_predictive middleCLA1(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C8),
        .S(S[16:9]),
        .C_out(C16)
    );

    cla_8bit_predictive middleCLA2(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C16),
        .S(S[24:17]),
        .C_out(C24)
    );

    cla_8bit_predictive upperCLA(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C24),
        .S(S[32:25]),
        .C_out(C32)
    );

endmodule