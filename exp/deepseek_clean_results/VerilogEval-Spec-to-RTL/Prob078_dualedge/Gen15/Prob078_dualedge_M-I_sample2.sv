module TopModule (
    input clk,
    input d,
    output reg q
);

    // Storage elements with enable
    reg q_pos, q_neg;
    reg d_prev;
    
    // Input change detection
    wire input_changed = (d != d_prev);
    
    // Positive edge capture with enable
    always @(posedge clk) begin
        d_prev <= d;
        if (input_changed) q_pos <= d;
    end

    // Negative edge capture with enable
    always @(negedge clk) begin
        if (input_changed) q_neg <= d;
    end

    // Output selection - registered for better timing
    always @(*) begin
        q = clk ? q_pos : q_neg;
    end

endmodule