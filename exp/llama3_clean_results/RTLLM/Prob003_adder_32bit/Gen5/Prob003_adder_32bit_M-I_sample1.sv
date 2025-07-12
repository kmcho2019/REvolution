// 8-bit Carry-Lookahead Adder with optimized carry generation
module cla_8bit_opt(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [8:1] G, P;
    wire [7:1] C;

    // Calculate Generate and Propagate signals
    for (genvar i = 1; i <= 8; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate Carry signals using optimized logic
    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 7; i++) begin
        assign C[i] = G[i] | (P[i] & (G[i-1] | (P[i-1] & C[i-2])));
    end
    assign C_out = G[8] | (P[8] & (G[7] | (P[7] & C[6])));

    // Calculate Sum signals
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// 32-bit Carry-Lookahead Adder with clock gating
module adder_32bit_opt(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32,
    input clk, // clock signal
    input enable // enable signal for clock gating
);

    wire C8, C16, C24;

    // Clock gating logic
    wire clk_gated;
    assign clk_gated = enable ? clk : 1'b0;

    cla_8bit_opt u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S[8:1]),
        .C_out(C8),
        .clk(clk_gated)
    );

    cla_8bit_opt u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C8),
        .S(S[16:9]),
        .C_out(C16),
        .clk(clk_gated)
    );

    cla_8bit_opt u3(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C16),
        .S(S[24:17]),
        .C_out(C24),
        .clk(clk_gated)
    );

    cla_8bit_opt u4(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C24),
        .S(S[32:25]),
        .C_out(C32),
        .clk(clk_gated)
    );

endmodule