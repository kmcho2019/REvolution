module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)
localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam CNT_MAX = (NUM_DIV/2) - 1;

reg [CNT_WIDTH-1:0] cnt;
reg toggle;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= '0;
    end else begin
        cnt <= (cnt == CNT_MAX) ? '0 : cnt + 1;
    end
end

// Toggle generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end else if (cnt == CNT_MAX) begin
        toggle <= ~toggle;
    end
end

// Continuous output assignment
assign clk_div = toggle;

endmodule