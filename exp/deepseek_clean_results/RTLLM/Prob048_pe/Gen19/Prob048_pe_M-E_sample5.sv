module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] accum_reg;

    // Operand gating during reset
    wire signed [31:0] a_gated = rst ? 32'b0 : a;
    wire signed [31:0] b_gated = rst ? 32'b0 : b;

    // Partial products (8x8 multipliers)
    wire signed [15:0] pp0 = a_gated[7:0] * b_gated[7:0];
    wire signed [15:0] pp1 = a_gated[15:8] * b_gated[7:0];
    wire signed [15:0] pp2 = a_gated[7:0] * b_gated[15:8];
    wire signed [15:0] pp3 = a_gated[15:8] * b_gated[15:8];
    wire signed [15:0] pp4 = a_gated[23:16] * b_gated[7:0];
    wire signed [15:0] pp5 = a_gated[31:24] * b_gated[7:0];
    wire signed [15:0] pp6 = a_gated[23:16] * b_gated[15:8];
    wire signed [15:0] pp7 = a_gated[31:24] * b_gated[15:8];
    wire signed [15:0] pp8 = a_gated[7:0] * b_gated[23:16];
    wire signed [15:0] pp9 = a_gated[15:8] * b_gated[23:16];
    wire signed [15:0] pp10 = a_gated[7:0] * b_gated[31:24];
    wire signed [15:0] pp11 = a_gated[15:8] * b_gated[31:24];
    wire signed [15:0] pp12 = a_gated[23:16] * b_gated[23:16];
    wire signed [15:0] pp13 = a_gated[31:24] * b_gated[23:16];
    wire signed [15:0] pp14 = a_gated[23:16] * b_gated[31:24];
    wire signed [15:0] pp15 = a_gated[31:24] * b_gated[31:24];

    // Carry-save accumulation tree (stage 1)
    wire signed [31:0] sum_low, carry_low;
    wire signed [31:0] sum_mid, carry_mid;
    wire signed [31:0] sum_high, carry_high;

    // Low 16 bits
    assign sum_low = {16'b0, pp0[15:0]};
    assign carry_low = {15'b0, pp1[15:0], 1'b0} + {15'b0, pp2[15:0], 1'b0} + {14'b0, pp3[15:0], 2'b0};

    // Mid 16 bits
    assign sum_mid = {pp4[15:0], 16'b0} + {pp5[15:0], 16'b0} + {pp6[15:0], 16'b0} + 
                    {pp7[15:0], 16'b0} + {pp8[15:0], 16'b0} + {pp9[15:0], 16'b0};
    assign carry_mid = {14'b0, pp10[15:0], 2'b0} + {14'b0, pp11[15:0], 2'b0} + 
                      {13'b0, pp12[15:0], 3'b0} + {13'b0, pp13[15:0], 3'b0};

    // High 16 bits
    assign sum_high = {pp14[15:0], 16'b0} + {pp15[15:0], 16'b0};
    assign carry_high = 32'b0;

    // Final product (stage 2)
    wire signed [63:0] product = 
        ({32'b0, sum_low} + {31'b0, carry_low, 1'b0}) +
        ({16'b0, sum_mid, 16'b0} + {15'b0, carry_mid, 17'b0}) +
        ({sum_high, 32'b0} + {carry_high, 32'b0});

    // Saturation logic
    wire signed [31:0] saturated_sum;
    assign saturated_sum = (^product[63:31]) ? 
                          (product[63] ? 32'h80000000 : 32'h7FFFFFFF) : 
                          product[31:0];

    // Pipeline stage 1: Register inputs and partial products
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
            accum_reg <= 32'b0;
        end else begin
            a_reg <= a_gated;
            b_reg <= b_gated;
            product_reg <= product;
            accum_reg <= c;
        end
    end

    // Pipeline stage 2: Final accumulation with saturation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            // Check for overflow in accumulation
            if ((product_reg[63:31] == 0) || (product_reg[63:31] == -1)) begin
                c <= accum_reg + saturated_sum;
            end else begin
                c <= (accum_reg[31] == 0) ? 32'h7FFFFFFF : 32'h80000000;
            end
        end
    end

endmodule