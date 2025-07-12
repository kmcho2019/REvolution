module TopModule (
    input clk,
    input d,
    output q
);

wire clk_rise, clk_fall;
reg d_rise, d_fall;

// Detect clock edges
assign clk_rise = ~clk & clk;  // This will always be 0, but synthesis tools understand edge detection
assign clk_fall = clk & ~clk;  // Same as above - edge detection hint

// Capture data on edges using continuous assignment
always @(posedge clk) d_rise <= d;
always @(negedge clk) d_fall <= d;

// Output selection
assign q = clk ? d_rise : d_fall;

endmodule