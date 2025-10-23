// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out,
    input clk, // Added clock input for clock gating
    input enable // Added enable input for clock gating
);

    wire [16:1] G, P;
    wire [15:1] C;

    // Clock gating to reduce power consumption
    reg [16:1] G_reg, P_reg;
    reg [15:1] C_reg;

    always @(posedge clk) begin
        if (enable) begin
            // Calculate G and P values
            for (genvar i = 1; i <= 16; i++) begin
                G_reg[i] <= A[i] & B[i];
                P_reg[i] <= A[i] ^ B[i];
            end

            // Calculate C values
            C_reg[1] <= G_reg[1] + (P_reg[1] & C_in);
            for (genvar i = 2; i <= 15; i++) begin
                C_reg[i] <= G_reg[i] + (P_reg[i] & C_reg[i-1]);
            end
        end
    end

    assign G = G_reg;
    assign P = P_reg;
    assign C = C_reg;

    assign C_out = G[16] + (P[16] & C[15]);

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
    output C32,
    input clk, // Added clock input for clock gating
    input enable // Added enable input for clock gating
);

    wire C16;

    // 16-bit CLA block for lower 16 bits
    cla_16bit u1(
      .A(A[16:1]),
      .B(B[16:1]),
      .C_in(1'b0),
      .S(S[16:1]),
      .C_out(C16),
      .clk(clk),
      .enable(enable)
    );

    // 16-bit CLA block for upper 16 bits
    cla_16bit u2(
      .A(A[32:17]),
      .B(B[32:17]),
      .C_in(C16),
      .S(S[32:17]),
      .C_out(C32),
      .clk(clk),
      .enable(enable)
    );

endmodule