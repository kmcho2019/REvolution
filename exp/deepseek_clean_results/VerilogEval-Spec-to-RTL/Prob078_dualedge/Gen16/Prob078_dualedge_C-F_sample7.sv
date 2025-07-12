module TopModule (
    input clk,
    input d,
    output q
);

    // Storage elements with change detection
    reg q_pos, q_neg;
    reg last_d;  // For detecting input changes
    
    // Track input changes to reduce unnecessary toggles
    always @(posedge clk) last_d <= d;

    // Positive edge capture (only when input changes)
    always @(posedge clk) begin
        if (d != last_d) q_pos <= d;
    end

    // Negative edge capture (only when input changes)
    always @(negedge clk) begin
        if (d != last_d) q_neg <= d;
    end

    // Optimal output selection
    assign q = clk ? q_pos : q_neg;

endmodule