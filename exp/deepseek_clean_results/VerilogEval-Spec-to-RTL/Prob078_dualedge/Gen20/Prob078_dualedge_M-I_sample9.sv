module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;
    reg d_prev;
    
    // Track input changes
    always @(posedge clk) d_prev <= d;
    
    // Positive edge FF (always active)
    always @(posedge clk) q_pos <= d;
    
    // Negative edge FF (only when input changed)
    always @(negedge clk) begin
        if (d != d_prev) q_neg <= d;
    end
    
    // Output selection - direct wiring
    assign q = clk ? q_pos : q_neg;

endmodule