module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [15:0] sum [7:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_out_reg <= 0;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 0;
        end
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        sum[0] <= {8'd0, mul_a_reg} * mul_b_reg[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= {8'd0, mul_a_reg} * mul_b_reg[i] << i;
        end
        mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
    end else begin
        mul_en_out_reg <= mul_en_out_reg;
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
        mul_out_reg <= mul_out_reg;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= sum[i];
        end
    end
end

always @(*) begin
    mul_en_out = mul_en_out_reg;
    if (mul_en_out) begin
        mul_out = mul_out_reg;
    end else begin
        mul_out = 0;
    end
end

endmodule