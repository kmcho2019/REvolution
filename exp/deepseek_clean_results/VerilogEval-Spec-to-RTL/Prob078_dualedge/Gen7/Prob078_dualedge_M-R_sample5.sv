module TopModule (
    input clk,
    input d,
    output q
);

    wire q_pos, q_neg;

    // Positive edge capture
    assign q_pos = clk ? d : q_pos;

    // Negative edge capture
    assign q_neg = ~clk ? d : q_neg;

    // Output selection
    assign q = clk ? q_pos : q_neg;

endmodule