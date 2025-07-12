module TopModule (
    input clk,
    input d,
    output q
);

    // Storage elements
    reg q_pos;          // Positive edge triggered FF
    reg q_neg;          // Negative edge triggered FF
    reg d_prev = 1'b0;  // Previous input value for change detection
    
    // Clock gating signal
    wire clk_neg_en = (d != d_prev);  // Only enable on input changes
    
    // Positive edge capture (always enabled)
    always @(posedge clk) begin
        q_pos <= d;
        d_prev <= d;  // Update shadow register
    end

    // Negative edge capture (gated)
    always @(negedge clk) begin
        if (clk_neg_en) begin
            q_neg <= d;
        end
    end

    // Optimized output selection (XOR-based mux)
    assign q = q_pos ^ q_neg ^ clk;

endmodule