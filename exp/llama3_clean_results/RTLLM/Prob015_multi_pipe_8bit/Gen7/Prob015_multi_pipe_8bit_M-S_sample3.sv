// input_partial_product_stage.v
module input_partial_product_stage (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg [15:0] partial_products [7:0],
    output reg mul_en_out_reg
);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        for (int i = 0; i < 8; i++) begin
            partial_products[i] <= 16'd0;
        end
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
        for (int i = 0; i < 8; i++) begin
            partial_products[i] <= (mul_b[i] == 1'b1) ? {8'd0, mul_a} << i : 16'd0;
        end
    end else begin
        mul_en_out_reg <= 1'b0;
        for (int i = 0; i < 8; i++) begin
            partial_products[i] <= 16'd0;
        end
    end
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

wire [15:0] partial_products [7:0];
reg [15:0] final_product;
reg mul_en_out_reg;

input_partial_product_stage u_input_partial_product_stage (
    .clk(clk),
    .rst_n(rst_n),
    .mul_en_in(mul_en_in),
    .mul_a(mul_a),
    .mul_b(mul_b),
    .partial_products(partial_products),
    .mul_en_out_reg(mul_en_out_reg)
);

always @ (posedge clk) begin
    final_product <= 16'd0;
    for (int i = 0; i < 8; i++) begin
        final_product <= final_product + partial_products[i];
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? final_product : 16'd0;

endmodule