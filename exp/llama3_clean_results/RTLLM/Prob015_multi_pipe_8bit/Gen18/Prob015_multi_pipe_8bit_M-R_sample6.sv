module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] product_reg;
reg mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        product_reg <= 16'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

reg [15:0] temp_product;
always @(posedge clk) begin
    if (mul_b_reg[0]) begin
        temp_product <= mul_a_reg;
    end else begin
        temp_product <= 16'b0;
    end
end

reg [15:0] stage1_product;
assign stage1_product = (mul_b_reg[1])? (mul_a_reg << 1) : 16'b0;

reg [15:0] stage2_product;
assign stage2_product = (mul_b_reg[2])? (mul_a_reg << 2) : 16'b0;

reg [15:0] stage3_product;
assign stage3_product = (mul_b_reg[3])? (mul_a_reg << 3) : 16'b0;

reg [15:0] stage4_product;
assign stage4_product = (mul_b_reg[4])? (mul_a_reg << 4) : 16'b0;

reg [15:0] stage5_product;
assign stage5_product = (mul_b_reg[5])? (mul_a_reg << 5) : 16'b0;

reg [15:0] stage6_product;
assign stage6_product = (mul_b_reg[6])? (mul_a_reg << 6) : 16'b0;

reg [15:0] stage7_product;
assign stage7_product = (mul_b_reg[7])? (mul_a_reg << 7) : 16'b0;

reg [15:0] sum1;
always @(posedge clk) begin
    sum1 <= temp_product + stage1_product;
end

reg [15:0] sum2;
always @(posedge clk) begin
    sum2 <= sum1 + stage2_product;
end

reg [15:0] sum3;
always @(posedge clk) begin
    sum3 <= sum2 + stage3_product;
end

reg [15:0] sum4;
always @(posedge clk) begin
    sum4 <= sum3 + stage4_product;
end

reg [15:0] sum5;
always @(posedge clk) begin
    sum5 <= sum4 + stage5_product;
end

reg [15:0] sum6;
always @(posedge clk) begin
    sum6 <= sum5 + stage6_product;
end

reg [15:0] sum7;
always @(posedge clk) begin
    sum7 <= sum6 + stage7_product;
end

reg [15:0] final_product;
always @(posedge clk) begin
    final_product <= sum7;
end

assign mul_out = final_product;
assign mul_en_out = mul_en_out_reg;

endmodule