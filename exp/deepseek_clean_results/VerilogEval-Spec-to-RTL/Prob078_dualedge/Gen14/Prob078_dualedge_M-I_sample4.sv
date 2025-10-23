module TopModule (
    input clk,
    input d,
    output q
);

    // Sequential elements
    reg q_pos;  // Positive edge FF
    reg q_neg;  // Negative edge FF
    reg d_prev; // Previous input for stability detection
    
    // Stability detection and clock gating
    wire input_changed = (d != d_prev);
    wire posedge_en = input_changed;
    wire negedge_en = input_changed;

    // Track previous input
    always @(posedge clk) begin
        d_prev <= d;
    end

    // Gated positive edge FF
    always @(posedge clk) begin
        if (posedge_en) q_pos <= d;
    end

    // Gated negative edge FF
    always @(negedge clk) begin
        if (negedge_en) q_neg <= d;
    end

    // Optimized output selection
    assign q = clk ? q_pos : q_neg;

endmodule