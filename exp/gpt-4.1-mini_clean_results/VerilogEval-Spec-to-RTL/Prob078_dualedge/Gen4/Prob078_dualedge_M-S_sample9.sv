module TopModule (
    input clk,
    input d,
    output reg q
);

reg toggle_clk;

// Toggle toggle_clk on every edge of clk by sampling clk in a register and detecting edges
reg clk_d;
always @(posedge clk) clk_d <= 1;
always @(negedge clk) clk_d <= 0;

always @(posedge clk) toggle_clk <= ~toggle_clk;

// Use toggle_clk to clock a single flip-flop capturing d
always @(posedge toggle_clk) q <= d;

endmodule