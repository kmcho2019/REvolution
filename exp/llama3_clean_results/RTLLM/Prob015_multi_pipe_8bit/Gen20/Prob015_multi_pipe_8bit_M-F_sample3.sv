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
reg [15:0] partial_product;
reg [15:0] partial_sum;
reg [15:0] final_product;
reg [1:0] mul_en_out_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        partial_product <= 16'b0;
        partial_sum <= 16'b0;
        final_product <= 16'b0;
        mul_en_out_reg <= 2'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        // Input Control
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Partial Product Generation Stage
        partial_product <= {8'b0, mul_a_reg} * {8'b0, mul_b_reg};

        // Partial Sum Calculation Stage
        partial_sum <= partial_product;

        // Final Product Calculation Stage
        final_product <= partial_sum;

        // Output Enable Signal
        mul_en_out_reg <= {mul_en_out_reg[0], mul_en_in};

        // Output Assignment
        if (mul_en_out_reg[1]) begin
            mul_en_out <= 1'b1;
            mul_out <= final_product;
        end else begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
    end
end

endmodule