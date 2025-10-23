// input_stage.v
module input_stage (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg [7:0] mul_a_reg,
    output reg [7:0] mul_b_reg,
    output reg mul_en_out_reg
);

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

endmodule

// partial_product_stage.v
module partial_product_stage (
    input [7:0] mul_a,
    input [7:0] mul_b,
    output [15:0] partial_products [7:0]
);

genvar i;
generate
    for (i = 0; i < 8; i++) begin: partial_product_gen
        assign partial_products[i] = (mul_b[i] == 1'b1) ? {8'd0, mul_a} << i : 16'd0;
    end
endgenerate

endmodule

// addition_stage.v
module addition_stage (
    input [15:0] partial_products [7:0],
    output [15:0] final_product
);

reg [15:0] sum;

always @ (*) begin
    sum = 16'd0;
    for (int i = 0; i < 8; i++) begin
        sum = sum + partial_products[i];
    end
    final_product = sum;
end

endmodule

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

wire [7:0] mul_a_reg;
wire [7:0] mul_b_reg;
wire mul_en_out_reg;
wire [15:0] partial_products [7:0];
wire [15:0] final_product;

input_stage u_input_stage (
    .clk(clk),
    .rst_n(rst_n),
    .mul_en_in(mul_en_in),
    .mul_a(mul_a),
    .mul_b(mul_b),
    .mul_a_reg(mul_a_reg),
    .mul_b_reg(mul_b_reg),
    .mul_en_out_reg(mul_en_out_reg)
);

partial_product_stage u_partial_product_stage (
    .mul_a(mul_a_reg),
    .mul_b(mul_b_reg),
    .partial_products(partial_products)
);

addition_stage u_addition_stage (
    .partial_products(partial_products),
    .final_product(final_product)
);

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? final_product : 16'd0;

endmodule