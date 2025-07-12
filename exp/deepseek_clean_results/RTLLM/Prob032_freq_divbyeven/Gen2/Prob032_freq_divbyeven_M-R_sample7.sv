module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6; // Default division factor (must be even)

reg [3:0] cnt;
reg div_toggle;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        div_toggle <= 1'b0;
    end
    else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 4'b0;
            div_toggle <= ~div_toggle;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = div_toggle;

endmodule