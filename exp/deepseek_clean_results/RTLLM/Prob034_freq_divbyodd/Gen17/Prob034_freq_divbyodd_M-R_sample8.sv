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

localparam HALF_CYCLE = (NUM_DIV - 1) >> 1;  // Arithmetic right shift for division by 2
reg [31:0] cnt_pos, cnt_neg;
wire pos_toggle, neg_toggle;

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

// Toggle signals using continuous assignment
assign pos_toggle = (cnt_pos >= HALF_CYCLE) & (cnt_pos != NUM_DIV - 1);
assign neg_toggle = (cnt_neg >= HALF_CYCLE) & (cnt_neg != NUM_DIV - 1);

// Combine toggle signals with XOR for precise edges
assign clk_div = pos_toggle ^ neg_toggle;

endmodule