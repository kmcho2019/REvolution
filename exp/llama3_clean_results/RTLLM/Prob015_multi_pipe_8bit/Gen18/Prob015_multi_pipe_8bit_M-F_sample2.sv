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
reg [15:0] final_product;
reg mul_en_reg;
reg mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        partial_sum <= 16'b0;
        final_product <= 16'b0;
        mul_en_reg <= 1'b0;
        mul_en_out_reg <= 1'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        // Input Stage
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_reg <= 1'b1;
            partial_sum <= 16'b0;
        end
        
        // Partial Product Generation and Summation Stage
        if (mul_en_reg && mul_en_in == 1'b0) begin
            for (int i = 0; i < 8; i++) begin
                if (mul_b_reg[i]) begin
                    partial_sum <= partial_sum + ({8'b0, mul_a_reg} << i);
                end
            end
            mul_en_reg <= 1'b0;
            mul_en_out_reg <= 1'b1;
        end
        
        // Output Stage
        if (mul_en_out_reg) begin
            mul_out <= partial_sum;
            mul_en_out <= 1'b1;
            mul_en_out_reg <= 1'b0;
        end
    end
end

endmodule