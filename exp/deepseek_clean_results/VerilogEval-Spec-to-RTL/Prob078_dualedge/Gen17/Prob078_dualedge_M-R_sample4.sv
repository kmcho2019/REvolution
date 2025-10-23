module TopModule (
    input clk,
    input d,
    output q
);

    // Edge-triggered sampling using continuous assignments
    wire q_pos = (clk && !$past(clk)) ? d : $past(q_pos);
    wire q_neg = (!clk && $past(clk)) ? d : $past(q_neg);
    
    // Output selection - same as original
    assign q = clk ? q_pos : q_neg;

endmodule