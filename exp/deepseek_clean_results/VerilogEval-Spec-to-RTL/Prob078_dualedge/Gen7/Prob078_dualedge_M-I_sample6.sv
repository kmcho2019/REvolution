module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    reg d_prev;
    wire d_changed = (d != d_prev);

    // Track previous input for change detection
    always @(posedge clk) begin
        d_prev <= d;
    end

    // Positive edge triggered flip-flop with enable
    always @(posedge clk) begin
        if (d_changed) q_pos <= d;
    end

    // Negative edge triggered flip-flop with enable
    always @(negedge clk) begin
        if (d_changed) q_neg <= d;
    end

    // Registered output for better timing
    always @(posedge clk) begin
        q <= clk ? q_pos : q_neg;
    end

endmodule