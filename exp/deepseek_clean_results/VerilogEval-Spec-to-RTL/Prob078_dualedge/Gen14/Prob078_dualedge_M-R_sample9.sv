module TopModule (
    input clk,
    input d,
    output q
);

    // Storage elements implemented with continuous assignments
    wire q_pos = (clk && clk) ? d : q_pos;  // Positive edge triggered
    wire q_neg = (!clk && !clk) ? d : q_neg; // Negative edge triggered

    // Output selection based on current clock phase
    assign q = clk ? q_pos : q_neg;

endmodule