module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] sum [8:0];
reg [15:0] mul_out_reg;

integer i;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        for (i = 0; i <= 8; i++) begin
            sum[i] <= 16'b0;
        end
        mul_out_reg <= 16'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, mul_en_out_reg[7:1]};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        // Generate partial products
        sum[0] <= 16'b0;
        for (i = 0; i < 8; i++) begin
            if (mul_b_reg[i])
                sum[i+1] <= sum[i] + (mul_a_reg << i);
            else
                sum[i+1] <= sum[i];
        end
        mul_out_reg <= sum[8];
        mul_en_out <= mul_en_out_reg[7];
        if (mul_en_out)
            mul_out <= mul_out_reg;
        else
            mul_out <= 16'b0;
    end
end

endmodule