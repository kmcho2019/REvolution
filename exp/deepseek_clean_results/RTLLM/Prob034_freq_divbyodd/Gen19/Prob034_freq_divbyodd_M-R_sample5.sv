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

localparam HALF_CYCLE = (NUM_DIV - 1) / 2;
reg [31:0] cnt_pos, cnt_neg;
wire toggle_pos, toggle_neg;
wire clk_pos, clk_neg;

// Positive edge counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
    end else begin
        cnt_pos <= (cnt_pos == NUM_DIV - 1) ? 0 : cnt_pos + 1;
    end
end

// Negative edge counter
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
    end else begin
        cnt_neg <= (cnt_neg == NUM_DIV - 1) ? 0 : cnt_neg + 1;
    end
end

// Toggle signals
assign toggle_pos = (cnt_pos == HALF_CYCLE) || (cnt_pos == NUM_DIV - 1);
assign toggle_neg = (cnt_neg == HALF_CYCLE) || (cnt_neg == NUM_DIV - 1);

// Clock generation
assign clk_pos = (cnt_pos > HALF_CYCLE) ? 1'b1 : 1'b0;
assign clk_neg = (cnt_neg > HALF_CYCLE) ? 1'b1 : 1'b0;

// Output clock
assign clk_div = clk_pos | clk_neg;

endmodule