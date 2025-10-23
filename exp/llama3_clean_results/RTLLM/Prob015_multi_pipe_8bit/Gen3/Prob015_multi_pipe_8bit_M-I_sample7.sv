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
reg [15:0] product;
reg [15:0] partial_product;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        product <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        product <= 0;
    end else if (mul_en_out_reg) begin
        partial_product <= 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (mul_b_reg[i] == 1) begin
                partial_product <= partial_product + (mul_a_reg << i);
            end
        end
        product <= partial_product;
        mul_en_out_reg <= 0;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_en_out_reg? product : 0;

endmodule