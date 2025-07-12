module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_rising;
reg clk_falling;

// Detect rising edge
always @(posedge clk) clk_rising <= 1'b1;
always @(negedge clk) clk_rising <= 1'b0;

// Detect falling edge
always @(posedge clk) clk_falling <= 1'b0;
always @(negedge clk) clk_falling <= 1'b1;

// Dual-edge triggered flip-flop
always @(posedge clk or negedge clk)
if (clk_rising)
    q <= d;
else if (clk_falling)
    q <= d;

endmodule