module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
wire clk_state = clk;

// Positive edge capture
assign q_pos = clk_state ? d : q_pos;

// Negative edge capture
assign q_neg = ~clk_state ? d : q_neg;

// Output selection
assign q = clk_state ? q_pos : q_neg;

endmodule