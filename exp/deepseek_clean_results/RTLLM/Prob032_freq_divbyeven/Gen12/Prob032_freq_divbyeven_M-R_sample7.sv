module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4;       // Must be even number
parameter CNT_WIDTH = 4;     // Counter width (adjust as needed)

reg [CNT_WIDTH-1:0] cnt;
reg div_toggle;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        div_toggle <= 1'b0;
    end else begin
        if (cnt == NUM_DIV-1) begin
            cnt <= {CNT_WIDTH{1'b0}};
            div_toggle <= ~div_toggle;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = div_toggle ^ (cnt >= (NUM_DIV/2));

endmodule