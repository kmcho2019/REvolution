module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Validate odd parameter
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam CNT_MAX = NUM_DIV - 1;
localparam CNT_HALF = (NUM_DIV - 1)/2;

reg [31:0] cnt_pos, cnt_neg;
reg clk_pos, clk_neg;

// Positive edge counter (rising edge triggered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        clk_pos <= 0;
    end else begin
        cnt_pos <= (cnt_pos == CNT_MAX) ? 0 : cnt_pos + 1;
        clk_pos <= (cnt_pos < CNT_HALF) ? 1'b1 : 1'b0;
    end
end

// Negative edge counter (falling edge triggered)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        clk_neg <= 0;
    end else begin
        cnt_neg <= (cnt_neg == CNT_MAX) ? 0 : cnt_neg + 1;
        clk_neg <= (cnt_neg < CNT_HALF) ? 1'b1 : 1'b0;
    end
end

// Combined output clock (combinational)
assign clk_div = clk_pos | clk_neg;

endmodule