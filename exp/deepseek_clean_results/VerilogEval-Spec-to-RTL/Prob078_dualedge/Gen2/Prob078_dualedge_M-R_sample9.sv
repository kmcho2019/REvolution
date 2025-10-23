module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
reg prev_clk;

// Detect clock edges
wire pos_edge = ~prev_clk & clk;
wire neg_edge = prev_clk & ~clk;

// Track previous clock state
always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

// Positive edge triggered behavior using assign
assign q_pos = pos_edge ? d : q_pos;

// Negative edge triggered behavior using assign
assign q_neg = neg_edge ? d : q_neg;

// Output selection based on current clock state
assign q = clk ? q_pos : q_neg;

endmodule