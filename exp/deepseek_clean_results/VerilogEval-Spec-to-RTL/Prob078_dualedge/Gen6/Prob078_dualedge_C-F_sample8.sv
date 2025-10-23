module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    reg d_prev;

    // Clock gating logic - only update when input changes
    wire posedge_update = (d != d_prev);
    wire negedge_update = (d != d_prev);

    // Positive edge triggered flip-flop with gating
    always @(posedge clk) begin
        d_prev <= d;
        if (posedge_update) q_pos <= d;
    end

    // Negative edge triggered flip-flop with gating
    always @(negedge clk) begin
        if (negedge_update) q_neg <= d;
    end

    // Registered output for better timing
    always @(posedge clk or negedge clk) begin
        q <= clk ? q_pos : q_neg;
    end

endmodule