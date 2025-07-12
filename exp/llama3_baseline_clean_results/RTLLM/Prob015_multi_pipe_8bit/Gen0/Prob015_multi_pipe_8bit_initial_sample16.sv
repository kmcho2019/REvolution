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
wire [15:0] temp [7:0];
reg [15:0] sum [7:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'd0;
        end
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
        // Generate partial products
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                temp[i] = {8'b0, mul_a_reg} << i;
            end else begin
                temp[i] = 16'd0;
            end
        end
        // Calculate partial sums
        sum[0] <= temp[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + temp[i];
        end
        // Update final product
        mul_out_reg <= sum[7];
    end
end

always @(*) begin
    mul_en_out = mul_en_out_reg;
    if (mul_en_out) begin
        mul_out = mul_out_reg;
    end else begin
        mul_out = 16'd0;
    end
end

endmodule