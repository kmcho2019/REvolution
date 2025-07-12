module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    reg clk_prev;

    // Track clock state for gating
    always @(posedge clk or negedge clk) begin
        clk_prev <= clk;
    end

    // Positive edge triggered flip-flop (only updates on posedge)
    always @(posedge clk) begin
        if (clk && !clk_prev) begin  // Rising edge detection
            q_pos <= d;
        end
    end

    // Negative edge triggered flip-flop (only updates on negedge)
    always @(negedge clk) begin
        if (!clk && clk_prev) begin  // Falling edge detection
            q_neg <= d;
        end
    end

    // Registered output selection
    always @(posedge clk or negedge clk) begin
        q <= clk ? q_pos : q_neg;
    end

endmodule