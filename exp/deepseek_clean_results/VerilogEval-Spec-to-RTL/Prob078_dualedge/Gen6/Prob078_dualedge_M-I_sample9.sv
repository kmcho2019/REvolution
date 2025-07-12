module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
reg d_prev;

// Track input changes to enable clock gating
always @(posedge clk) begin
    d_prev <= d;
end

// Positive edge triggered flip-flop (only updates when input changes)
always @(posedge clk) begin
    if (d != d_prev) q_pos <= d;
end

// Negative edge triggered flip-flop (using clock inversion through XOR)
always @(posedge (clk ^ 1'b1)) begin
    if (d != d_prev) q_neg <= d;
end

// Output selection based on current clock state
assign q = clk ? q_pos : q_neg;

endmodule