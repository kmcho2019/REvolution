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
reg mul_en_out_reg;
reg mul_en_out_pipe;

// Input Buffering
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Partial Product Generation
always @(posedge clk) begin
    partial_product <= 16'b0;
    for (int i = 0; i < 8; i++) begin
        if (mul_b_reg[i])
            partial_product <= partial_product + ({8'b0, mul_a_reg} << i);
    end
end

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_sum <= 16'b0;
    end else if (mul_en_out_reg) begin
        partial_sum <= partial_product;
    end else begin
        partial_sum <= 16'b0;
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_product <= 16'b0;
    end else if (mul_en_out_reg) begin
        final_product <= partial_sum;
    end else begin
        final_product <= 16'b0;
    end
end

// Output Pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_pipe <= 1'b0;
    end else begin
        mul_en_out_pipe <= mul_en_out_reg;
    end
end

// Output Assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else if (mul_en_out_pipe) begin
        mul_out <= final_product;
        mul_en_out <= 1'b1;
    end else begin
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end
end

endmodule