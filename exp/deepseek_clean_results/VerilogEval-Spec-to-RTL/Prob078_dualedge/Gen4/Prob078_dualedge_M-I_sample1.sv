module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    reg d_prev;

    // Store previous input for change detection
    always @(posedge clk or negedge clk) begin
        d_prev <= d;
    end

    // Positive edge triggered flip-flop (only update if input changed)
    always @(posedge clk) begin
        if (d != d_prev) q_pos <= d;
    end

    // Negative edge triggered flip-flop (only update if input changed)
    always @(negedge clk) begin
        if (d != d_prev) q_neg <= d;
    end

    // Registered output selection
    always @(posedge clk or negedge clk) begin
        q <= clk ? q_pos : q_neg;
    end

endmodule