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
reg [15:0] partial_sum;
reg mul_en_reg;
reg [15:0] final_product;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        partial_sum <= 16'b0;
        mul_en_reg <= 1'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= 1'b1;
    end else if (mul_en_reg) begin
        partial_sum <= 16'b0;
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                partial_sum <= partial_sum + ({8'b0, mul_a_reg} << i);
            end
        end
        mul_en_reg <= 1'b0;
        mul_en_out <= 1'b1;
        mul_out <= partial_sum;
    end
end

endmodule