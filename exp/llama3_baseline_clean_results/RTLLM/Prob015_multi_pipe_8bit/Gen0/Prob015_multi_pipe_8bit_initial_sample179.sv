module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
wire [15:0] temp [7:0];
wire [15:0] sum [7:0];

assign mul_en_out = mul_en_out_reg[0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_out_reg <= 0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= {mul_en_in};
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_a_reg <= mul_a_reg;
            mul_b_reg <= mul_b_reg;
        end

        if (mul_en_in) begin
            for (int i = 0; i < 8; i++) begin
                if (mul_b_reg[i]) begin
                    temp[i] = {8'd0, mul_a_reg} << i;
                end else begin
                    temp[i] = 16'd0;
                end
            end
        end else begin
            for (int i = 0; i < 8; i++) begin
                temp[i] = 16'd0;
            end
        end

        sum[0] = temp[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] = sum[i - 1] + temp[i];
        end

        mul_out_reg <= sum[7];
    end
end

assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule