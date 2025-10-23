module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input Stage
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_in_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_in_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_in_reg <= 1'b1;
    end
end

// Partial Product Generation Stage
reg [15:0] partial_product [7:0];
always @(*) begin
    for (int i = 0; i < 8; i++) begin
        if (mul_b_reg[i])
            partial_product[i] = mul_a_reg << i;
        else
            partial_product[i] = 16'b0;
    end
end

// Partial Sum Calculation Stage
reg [15:0] partial_sum [7:0];
always @(posedge clk) begin
    partial_sum[0] <= partial_product[0];
    for (int i = 1; i < 8; i++) begin
        partial_sum[i] <= partial_sum[i-1] + partial_product[i];
    end
end

// Accumulation Stage
reg [15:0] product_reg;
always @(posedge clk) begin
    if (mul_en_in_reg) begin
        product_reg <= partial_sum[7];
    end
end

// Output Stage
reg mul_en_out_reg;
always @(posedge clk) begin
    if (mul_en_in_reg) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? product_reg : 16'b0;

endmodule