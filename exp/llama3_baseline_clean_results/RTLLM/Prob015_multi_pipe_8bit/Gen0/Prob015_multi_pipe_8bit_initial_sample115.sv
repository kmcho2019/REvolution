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
reg [15:0] mul_out_reg;
wire [15:0] temp [7:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'd0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'd0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

assign mul_en_out = mul_en_out_reg[7];

always @(posedge clk) begin
    for (i = 0; i < 8; i++) begin
        if (mul_b_reg[i])
            temp[i] = {8'd0, mul_a_reg} << i;
        else
            temp[i] = 16'd0;
    end
end

reg [15:0] sum [7:0];

always @(posedge clk) begin
    sum[0] <= temp[0];
    for (i = 1; i < 8; i++) begin
        sum[i] <= sum[i-1] + temp[i];
    end
end

always @(posedge clk) begin
    if (mul_en_in)
        mul_out_reg <= sum[7];
    else
        mul_out_reg <= mul_out_reg;
end

always @(posedge clk) begin
    if (mul_en_out)
        mul_out <= mul_out_reg;
    else
        mul_out <= 16'd0;
end

endmodule