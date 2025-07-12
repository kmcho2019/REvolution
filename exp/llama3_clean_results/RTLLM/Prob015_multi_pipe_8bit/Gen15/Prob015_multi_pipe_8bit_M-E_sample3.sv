module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input Stage
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= 1'b1;
    end
end

// Partial Product Generation Stage
reg [15:0] partial_product;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_product <= 16'b0;
    end else if (mul_en_reg) begin
        partial_product <= {8'b0, mul_a_reg};
    end
end

// Partial Sum Calculation Stage
reg [15:0] partial_sum;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_sum <= 16'b0;
    end else if (mul_en_reg) begin
        partial_sum <= partial_product;
        for (int i = 1; i < 8; i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                partial_sum <= partial_sum + ({8'b0, mul_a_reg} << i);
            end
        end
    end
end

// Final Product Calculation Stage
reg [15:0] final_product;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_product <= 16'b0;
    end else if (mul_en_reg) begin
        final_product <= partial_sum;
    end
end

// Output Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else if (mul_en_reg) begin
        mul_en_out <= 1'b1;
        mul_out <= final_product;
    end else begin
        mul_en_out <= 1'b0;
    end
end

endmodule