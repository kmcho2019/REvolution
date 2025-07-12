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
reg [15:0] sum [7:0];
reg [15:0] mul_out_reg;

integer i;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        for (i = 0; i < 8; i++) begin
            sum[i] <= 0;
        end
        mul_out_reg <= 0;
    end else begin
        mul_en_out_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        sum[0] <= {8'd0, mul_a_reg} * (mul_b_reg[0] ? 1 : 0);
        for (i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + ({8'd0, mul_a_reg} * (mul_b_reg[i] ? 1 : 0)) << i;
        end
        mul_out_reg <= sum[7];
    end
end

always @ (*) begin
    mul_en_out = mul_en_out_reg;
    if (mul_en_out) begin
        mul_out = mul_out_reg;
    end else begin
        mul_out = 0;
    end
end

endmodule