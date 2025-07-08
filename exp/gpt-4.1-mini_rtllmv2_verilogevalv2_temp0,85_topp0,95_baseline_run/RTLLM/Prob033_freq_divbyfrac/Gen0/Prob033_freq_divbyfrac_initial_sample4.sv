module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

localparam MUL2_DIV_CLK = 7;  // 2 * division factor (3.5 * 2)

reg [2:0] cnt;  // 3 bits needed to count to 6
reg clk_div_pos;  // divided clock generated on posedge clock
reg clk_div_neg;  // divided clock generated on negedge clock

// Counter increments on rising edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 3'd0;
    else if (cnt == MUL2_DIV_CLK - 1)
        cnt <= 3'd0;
    else
        cnt <= cnt + 3'd1;
end

// Generate clk_div_pos: high for 4 cycles, low for 3 cycles in one pattern
// Pattern: counts 0..3 -> high (4 cycles), 4..6 -> low (3 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clk_div_pos <= 1'b0;
    else if (cnt < 4)
        clk_div_pos <= 1'b1;
    else
        clk_div_pos <= 1'b0;
end

// Generate clk_div_neg: delayed version generated on negedge clk
// Alternate pattern: counts 0..2 -> high (3 cycles), 3..6 -> low (4 cycles)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        clk_div_neg <= 1'b0;
    else if (cnt < 3)
        clk_div_neg <= 1'b1;
    else
        clk_div_neg <= 1'b0;
end

// OR the two clocks to produce the final fractional divided clock with balanced duty
assign clk_div = clk_div_pos | clk_div_neg;

endmodule