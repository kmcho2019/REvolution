module TopModule (
    input clk,
    input d,
    output q
);

reg d_rise, d_fall;

// Capture data on clock edges
always @(posedge clk) d_rise <= d;
always @(negedge clk) d_fall <= d;

// Output selection based on current clock state
assign q = clk ? d_rise : d_fall;

endmodule