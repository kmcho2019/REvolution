module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;

// Positive edge triggered update using continuous assignment
wire pos_update = clk & (clk !== q_pos);
assign q_pos = pos_update ? d : q_pos;

// Negative edge triggered update using continuous assignment
wire neg_update = ~clk & (clk !== q_neg);
assign q_neg = neg_update ? d : q_neg;

// Output selection remains the same
assign q = clk ? q_pos : q_neg;

endmodule