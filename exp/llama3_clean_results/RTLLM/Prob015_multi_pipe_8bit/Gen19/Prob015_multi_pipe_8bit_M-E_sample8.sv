module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] partial_product1;
reg [15:0] partial_product2;
reg [15:0] partial_product3;
reg [15:0] partial_product4;
reg [15:0] partial_sum1;
reg [15:0] partial_sum2;
reg [15:0] final_product;

always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        partial_product1 <= 16'b0;
        partial_product2 <= 16'b0;
        partial_product3 <= 16'b0;
        partial_product4 <= 16'b0;
        partial_sum1 <= 16'b0;
        partial_sum2 <= 16'b0;
        final_product <= 16'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Partial Product Generation Stage
        partial_product1 <= {8'b0, mul_a_reg} * {2'b0, mul_b_reg[1:0]};
        partial_product2 <= {8'b0, mul_a_reg} * {2'b0, mul_b_reg[3:2]} << 2;
        partial_product3 <= {8'b0, mul_a_reg} * {2'b0, mul_b_reg[5:4]} << 4;
        partial_product4 <= {8'b0, mul_a_reg} * {2'b0, mul_b_reg[7:6]} << 6;

        // Partial Sum Calculation Stage
        partial_sum1 <= partial_product1 + partial_product2;
        partial_sum2 <= partial_product3 + partial_product4;

        // Output Stage
        final_product <= partial_sum1 + partial_sum2;

        // Output Enable Signal
        if (mul_en_in) begin
            mul_en_out <= 1'b1;
            mul_out <= final_product;
        end else begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
    end
end

endmodule