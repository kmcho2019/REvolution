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
reg [15:0] mul_out_reg;
reg mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end
end

reg [15:0] temp [7:0];
always @(posedge clk) begin
    for (int i = 0; i < 8; i++) begin
        temp[i] <= (mul_b_reg[i]) ? (mul_a_reg << i) : 16'b0;
    end
end

always @(posedge clk) begin
    mul_out_reg <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
end

assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'b0;
assign mul_en_out = mul_en_out_reg;

endmodule