module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// calculate partial products based on multiplier bits
wire [7:0] partial_product0 = {4'b0, mul_a};
wire [7:0] partial_product1 = {3'b0, mul_a} << 1;
wire [7:0] partial_product2 = {2'b0, mul_a} << 2;
wire [7:0] partial_product3 = {1'b0, mul_a} << 3;

// first level of registers to store the partial products
reg [7:0] partial_product_reg0;
reg [7:0] partial_product_reg1;
reg [7:0] partial_product_reg2;
reg [7:0] partial_product_reg3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_product_reg0 <= 8'd0;
        partial_product_reg1 <= 8'd0;
        partial_product_reg2 <= 8'd0;
        partial_product_reg3 <= 8'd0;
    end else begin
        partial_product_reg0 <= (mul_b[0] == 1'b1) ? partial_product0 : 8'd0;
        partial_product_reg1 <= (mul_b[1] == 1'b1) ? partial_product1 : 8'd0;
        partial_product_reg2 <= (mul_b[2] == 1'b1) ? partial_product2 : 8'd0;
        partial_product_reg3 <= (mul_b[3] == 1'b1) ? partial_product3 : 8'd0;
    end
end

// first level of registers to store the sum
reg [7:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 8'd0;
    end else begin
        sum_reg <= partial_product_reg0 + partial_product_reg1 + partial_product_reg2 + partial_product_reg3;
    end
end

// second level of registers to store the final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_reg;
    end
end

endmodule