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
reg mul_en_reg;
reg [15:0] partial_product_reg;
reg [15:0] mul_out_reg;

// Input Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= 1'b1;
    end else begin
        mul_en_reg <= 1'b0;
    end
end

// Pipeline Stage
wire [15:0] partial_product;
assign partial_product = (
    (mul_b_reg[0] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0
) + (
    (mul_b_reg[1] == 1'b1) ? {8'b0, mul_a_reg} << 1 : 16'b0
) + (
    (mul_b_reg[2] == 1'b1) ? {8'b0, mul_a_reg} << 2 : 16'b0
) + (
    (mul_b_reg[3] == 1'b1) ? {8'b0, mul_a_reg} << 3 : 16'b0
) + (
    (mul_b_reg[4] == 1'b1) ? {8'b0, mul_a_reg} << 4 : 16'b0
) + (
    (mul_b_reg[5] == 1'b1) ? {8'b0, mul_a_reg} << 5 : 16'b0
) + (
    (mul_b_reg[6] == 1'b1) ? {8'b0, mul_a_reg} << 6 : 16'b0
) + (
    (mul_b_reg[7] == 1'b1) ? {8'b0, mul_a_reg} << 7 : 16'b0
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_product_reg <= 16'b0;
    end else if (mul_en_reg) begin
        partial_product_reg <= partial_product;
    end else begin
        partial_product_reg <= 16'b0;
    end
end

// Output Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= partial_product_reg;
    end
end

assign mul_en_out = mul_en_reg;
assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule