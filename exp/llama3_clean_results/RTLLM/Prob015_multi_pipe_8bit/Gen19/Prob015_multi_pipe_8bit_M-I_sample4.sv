module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Stage 1: Input Control and Registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_out_reg;

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

// Stage 2: Partial Product Generation
wire [15:0] partial_product;
assign partial_product = mul_a_reg * mul_b_reg;

// Stage 3: Final Product Calculation
reg [15:0] product_reg;
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        product_reg <= partial_product;
    end else begin
        product_reg <= 16'b0;
    end
end

// Output Assignment
assign mul_out = (mul_en_out_reg)? product_reg : 16'b0;
assign mul_en_out = mul_en_out_reg;

endmodule