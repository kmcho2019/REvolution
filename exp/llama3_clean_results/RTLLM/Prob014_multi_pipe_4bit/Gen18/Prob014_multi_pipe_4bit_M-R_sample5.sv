module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Partial product generation using assign statements
wire [7:0] partial_product_0 = (mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0;
wire [7:0] partial_product_1 = (mul_b[1] == 1'b1) ? {4'b0, mul_a} << 1 : 8'd0;
wire [7:0] partial_product_2 = (mul_b[2] == 1'b1) ? {4'b0, mul_a} << 2 : 8'd0;
wire [7:0] partial_product_3 = (mul_b[3] == 1'b1) ? {4'b0, mul_a} << 3 : 8'd0;

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Pipeline accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'd0;
    end else begin
        stage1_reg <= partial_product_0 + partial_product_1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        stage2_reg <= stage1_reg + partial_product_2 + partial_product_3;
        mul_out <= stage2_reg;
    end
end

endmodule