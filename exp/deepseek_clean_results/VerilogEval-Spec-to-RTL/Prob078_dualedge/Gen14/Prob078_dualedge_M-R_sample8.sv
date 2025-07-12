module TopModule (
    input clk,
    input d,
    output q
);

    // Edge detection wires
    wire clk_posedge = clk & ~$past(clk);
    wire clk_negedge = ~clk & $past(clk);

    // Flip-flop state wires
    wire q_pos, q_neg;

    // Positive edge triggered behavior
    assign q_pos = clk_posedge ? d : $past(q_pos);

    // Negative edge triggered behavior
    assign q_neg = clk_negedge ? d : $past(q_neg);

    // Output selection
    assign q = clk ? q_pos : q_neg;

endmodule