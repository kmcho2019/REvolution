module TopModule (
    input clk,
    input d,
    output q
);

    // Positive edge triggered path
    wire q_pos;
    assign q_pos = (clk && ~$past(clk)) ? d : $past(q_pos);

    // Negative edge triggered path
    wire q_neg;
    assign q_neg = (~clk && $past(clk)) ? d : $past(q_neg);

    // Output selection based on current clock phase
    assign q = clk ? q_pos : q_neg;

endmodule