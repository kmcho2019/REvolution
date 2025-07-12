module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam CNT_MAX = NUM_DIV - 1;
localparam CNT_HALF = (NUM_DIV - 1) / 2;

reg [31:0] pos_cnt, neg_cnt;
wire pos_toggle, neg_toggle;

// Positive edge counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
    end else begin
        pos_cnt <= (pos_cnt == CNT_MAX) ? 0 : pos_cnt + 1;
    end
end

// Negative edge counter
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 0;
    end else begin
        neg_cnt <= (neg_cnt == CNT_MAX) ? 0 : neg_cnt + 1;
    end
end

// Toggle signals generation
assign pos_toggle = (pos_cnt <= CNT_HALF);
assign neg_toggle = (neg_cnt <= CNT_HALF);

// Combined output clock
assign clk_div = pos_toggle | neg_toggle;

endmodule