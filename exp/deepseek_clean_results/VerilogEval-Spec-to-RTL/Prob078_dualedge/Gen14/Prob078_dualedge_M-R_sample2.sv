module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;
    reg last_clk;
    
    // Track clock state for edge detection
    always @(clk) begin
        last_clk <= clk;
    end

    // Positive edge capture using continuous assignment
    assign q_pos = (clk && !last_clk) ? d : q_pos;
    
    // Negative edge capture using continuous assignment
    assign q_neg = (!clk && last_clk) ? d : q_neg;
    
    // Output selection remains the same
    assign q = clk ? q_pos : q_neg;

endmodule