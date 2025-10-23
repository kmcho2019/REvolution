module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
reg clk_pos, clk_neg;

// Generate gated clocks
always @(*) begin
    clk_pos = clk;          // Positive edge FF gets clock normally
    clk_neg = ~clk;         // Negative edge FF gets inverted clock
end

// Positive edge triggered flip-flop (only toggles on rising edges)
always @(posedge clk_pos) begin
    q_pos <= d;
end

// Negative edge triggered flip-flop (only toggles on falling edges)
always @(posedge clk_neg) begin
    q_neg <= d;
end

// Output selection based on current clock state
assign q = clk ? q_pos : q_neg;

endmodule