module TopModule (
    input clk,
    input d,
    output q
);

    // Edge-triggered storage elements
    reg q_pos, q_neg;

    // Positive edge capture
    always @(posedge clk) q_pos <= d;
    
    // Negative edge capture
    always @(negedge clk) q_neg <= d;

    // Clock-synchronized output selection
    assign q = clk ? q_pos : q_neg;

    // Optional power optimization (uncomment if needed)
    // wire clk_enable = ...;  // Add clock gating logic here
    // always @(posedge clk) if (clk_enable) q_pos <= d;
    // always @(negedge clk) if (clk_enable) q_neg <= d;

endmodule