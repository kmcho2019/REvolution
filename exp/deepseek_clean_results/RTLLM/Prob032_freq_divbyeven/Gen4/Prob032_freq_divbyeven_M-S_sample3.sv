module freq_diveven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 4;  // Must be even (no validation for simplicity)

reg [3:0] cnt = 0;
reg div_reg = 0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        div_reg <= 0;
    end
    else if (cnt == NUM_DIV/2 - 1) begin
        cnt <= 0;
        div_reg <= ~div_reg;
    end
    else begin
        cnt <= cnt + 1;
    end
end

assign clk_div = div_reg;

endmodule