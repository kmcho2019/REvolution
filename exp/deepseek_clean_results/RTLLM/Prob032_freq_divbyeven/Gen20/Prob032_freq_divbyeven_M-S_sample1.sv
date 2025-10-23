module freq_diveven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2

localparam CNT_MAX = NUM_DIV/2 - 1;

reg [3:0] cnt;
reg toggle;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        toggle <= 0;
    end
    else begin
        if (cnt == CNT_MAX) begin
            cnt <= 0;
            toggle <= ~toggle;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = toggle;

endmodule