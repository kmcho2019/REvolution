module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
reg d_prev;

// Track input changes to minimize unnecessary updates
always @(posedge clk) begin
    d_prev <= d;
end

// Positive edge triggered flip-flop (enabled on rising edges)
always @(posedge clk) begin
    if (d != d_prev) q_pos <= d;
end

// Negative edge triggered flip-flop (enabled on falling edges)
always @(negedge clk) begin
    if (d != d_prev) q_neg <= d;
end

// Output selection based on current clock state
assign q = clk ? q_pos : q_neg;

endmodule