module freq_diveven #(
    parameter NUM_DIV = 4 // Must be an even number
) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

reg [3:0] cnt; // 4-bit counter
reg       clk_div_reg; // Register for divided clock output

assign clk_div = clk_div_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0;
        clk_div_reg <= 1'b0;
    end else if (cnt < (NUM_DIV / 2) - 1) begin
        cnt <= cnt + 1'b1;
    end else begin
        cnt <= 4'b0;
        clk_div_reg <= ~clk_div_reg;
    end
end

endmodule