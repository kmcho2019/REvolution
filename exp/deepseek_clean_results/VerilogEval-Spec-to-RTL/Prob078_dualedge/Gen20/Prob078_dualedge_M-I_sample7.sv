module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;
    reg d_prev;
    wire enable_neg;
    
    // Change detector for clock gating
    always @(posedge clk) d_prev <= d;
    assign enable_neg = (d != d_prev);
    
    // Positive edge FF (always enabled)
    always @(posedge clk) q_pos <= d;
    
    // Negative edge FF (conditionally enabled)
    always @(negedge clk) if (enable_neg) q_neg <= d;
    
    // Direct output selection without mux
    assign q = clk ? q_pos : q_neg;

endmodule