module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;
reg d_prev;

// Detect data changes for clock gating
always @(posedge clk) begin
    d_prev <= d;
end

wire data_changed = (d != d_prev);

// Positive edge triggered flip-flop (updates only on rising edges when data changes)
always @(posedge clk) begin
    if (data_changed) q_pos <= d;
end

// Negative edge triggered flip-flop (updates only on falling edges when data changes)
always @(negedge clk) begin
    if (data_changed) q_neg <= d;
end

// Registered output selection
always @(posedge clk) begin
    q <= clk ? q_pos : q_neg;
end

endmodule