module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [15:0] mul_out_reg;

assign mul_en_out = mul_en_in;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= mul_a * mul_b;
    end else begin
        mul_out_reg <= 16'b0;
    end
end

assign mul_out = (mul_en_in)? mul_out_reg : 16'b0;

endmodule