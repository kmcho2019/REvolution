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
reg [15:0] partial_products [7:0];
reg [15:0] sum;

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
genvar i;
generate
    for (i = 0; i < 8; i++) begin: partial_product_gen
        always @ (*) begin
            if (mul_b_reg[i] == 1'b1) begin
                partial_products[i] = {8'd0, mul_a_reg} << i;
            end else begin
                partial_products[i] = 16'd0;
            end
        end
    end
endgenerate

// Addition tree
reg [15:0] sum1, sum2, sum3, sum4;
always @ (*) begin
    sum1 = partial_products[0] + partial_products[1];
    sum2 = partial_products[2] + partial_products[3];
    sum3 = partial_products[4] + partial_products[5];
    sum4 = partial_products[6] + partial_products[7];
end

always @ (*) begin
    sum = sum1 + sum2 + sum3 + sum4;
end

// Output stage
always @ (posedge clk) begin
    if (mul_en_out_reg) begin
        mul_out <= sum;
    end else begin
        mul_out <= 16'd0;
    end
end

assign mul_en_out = mul_en_out_reg;

endmodule