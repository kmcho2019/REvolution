module freq_divbyeven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

reg [3:0] cnt; // 4-bit counter supports division up to 30

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else begin
        cnt <= (cnt == NUM_DIV - 1) ? 0 : cnt + 1;
    end
end

// Divided clock generation
assign clk_div = (cnt >= NUM_DIV/2) ? 1 : 0;

endmodule