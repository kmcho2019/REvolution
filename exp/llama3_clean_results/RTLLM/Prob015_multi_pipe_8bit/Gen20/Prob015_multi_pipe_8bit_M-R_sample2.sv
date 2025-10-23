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

wire [15:0] partial_product;
assign partial_product = (mul_b_reg[0]) ? {8'b0, mul_a_reg} : 16'b0;

wire [15:0] sum;
assign sum = partial_product + 
             (mul_b_reg[1] ? {7'b0, mul_a_reg, 1'b0} : 16'b0) + 
             (mul_b_reg[2] ? {6'b0, mul_a_reg, 2'b0} : 16'b0) + 
             (mul_b_reg[3] ? {5'b0, mul_a_reg, 3'b0} : 16'b0) + 
             (mul_b_reg[4] ? {4'b0, mul_a_reg, 4'b0} : 16'b0) + 
             (mul_b_reg[5] ? {3'b0, mul_a_reg, 5'b0} : 16'b0) + 
             (mul_b_reg[6] ? {2'b0, mul_a_reg, 6'b0} : 16'b0) + 
             (mul_b_reg[7] ? {1'b0, mul_a_reg, 7'b0} : 16'b0);

always @(posedge clk) begin
    if (mul_en_out_reg) begin
        product_reg <= sum;
    end else begin
        product_reg <= 16'b0;
    end
end

assign mul_out = product_reg;
assign mul_en_out = mul_en_out_reg;

endmodule