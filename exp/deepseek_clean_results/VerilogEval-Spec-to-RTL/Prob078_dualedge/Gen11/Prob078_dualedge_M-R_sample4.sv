module TopModule (
    input clk,
    input d,
    output q
);

wire pos_edge = clk && !$past(clk);  // Positive edge detect
wire neg_edge = !clk && $past(clk);  // Negative edge detect

reg q_pos, q_neg;

// Positive edge triggered flip-flop using continuous assignment
assign q_pos = pos_edge ? d : q_pos;

// Negative edge triggered flip-flop using continuous assignment
assign q_neg = neg_edge ? d : q_neg;

// Output selection based on current clock state
assign q = clk ? q_pos : q_neg;

endmodule