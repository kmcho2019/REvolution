module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4; // Default division factor (must be even)

reg [3:0] cnt;
wire cnt_max = (cnt == (NUM_DIV/2 - 1));
wire [3:0] next_cnt = (!rst_n) ? 4'b0 : (cnt_max ? 4'b0 : cnt + 1);
reg clk_div_reg;

always @(posedge clk) begin
    cnt <= next_cnt;
    if (cnt_max) begin
        clk_div_reg <= ~clk_div_reg;
    end
    if (!rst_n) begin
        clk_div_reg <= 1'b0;
    end
end

assign clk_div = clk_div_reg;

endmodule