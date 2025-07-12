module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
wire clk_delayed;

// Create a delayed version of the clock to detect edges
assign clk_delayed = ~clk;

// Positive edge capture using continuous assignment
assign q_pos = (clk & ~clk_delayed) ? d : q_pos;

// Negative edge capture using continuous assignment
assign q_neg = (~clk & clk_delayed) ? d : q_neg;

// Output selection based on current clock state
assign q = clk ? q_pos : q_neg;

endmodule