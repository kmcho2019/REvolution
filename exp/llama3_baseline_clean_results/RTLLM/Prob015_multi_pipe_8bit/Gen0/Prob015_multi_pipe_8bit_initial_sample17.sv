module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_out_reg;
wire [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_en_out_reg <= mul_en_out_reg;
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

always @(*) begin
    temp = 16'b0;
    for (int i = 0; i < 8; i++) begin
        if (mul_b_reg[i])
            temp = temp + (mul_a_reg << i);
    end
end

always @(posedge clk) begin
    sum <= temp;
end

always @(posedge clk) begin
    if (mul_en_out_reg)
        mul_out_reg <= sum;
    else
        mul_out_reg <= mul_out_reg;
end

always @(posedge clk) begin
    mul_en_out <= mul_en_out_reg;
end

always @(posedge clk) begin
    if (mul_en_out)
        mul_out <= mul_out_reg;
    else
        mul_out <= 16'b0;
end

endmodule