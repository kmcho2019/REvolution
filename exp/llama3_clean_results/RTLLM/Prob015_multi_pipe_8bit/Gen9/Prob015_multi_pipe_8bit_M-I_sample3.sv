// multi_pipe_8bit.v
module multi_pipe_8bit (
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
reg mul_en_out_reg;
reg [15:0] mul_out_reg;
reg [15:0] sum1_reg;
reg [15:0] sum2_reg;
reg [15:0] sum3_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
        mul_en_out_reg <= 1'b0;
    end
end

// Generate partial products
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin: partial_product_gen
        assign partial_products[i] = (mul_b_reg[i] == 1'b1) ? ({8'd0, mul_a_reg} << i) : 16'd0;
    end
endgenerate

// Addition tree
always @ (posedge clk) begin
    sum1_reg <= partial_products[0] + partial_products[1];
    sum2_reg <= partial_products[2] + partial_products[3];
    sum3_reg <= partial_products[4] + partial_products[5];
end

always @ (posedge clk) begin
    mul_out_reg <= sum1_reg + sum2_reg + sum3_reg + partial_products[6] + partial_products[7];
end

// Output stage
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'd0;

endmodule