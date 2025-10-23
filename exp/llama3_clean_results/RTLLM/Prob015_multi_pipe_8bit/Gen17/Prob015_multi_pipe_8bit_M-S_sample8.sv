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
reg mul_en_out_reg;
reg [15:0] product_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 1'b0;
        product_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
        product_reg <= 16'b0;
    end else if (mul_en_out_reg) begin
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i])
                product_reg <= product_reg + ({8'b0, mul_a_reg} << i);
        end
        mul_en_out_reg <= 1'b0;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? product_reg : 16'b0;

endmodule