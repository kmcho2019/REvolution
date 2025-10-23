module TopModule (
    input clk,
    input d,
    output q
);

    // Sequential elements with enable for power optimization
    reg q_pos;  // Positive edge capture
    reg q_neg;  // Negative edge capture
    reg d_prev; // Previous input for enable condition

    // Positive edge triggered flip-flop with enable
    always @(posedge clk) begin
        q_pos <= d;
        d_prev <= d;  // Store for enable comparison
    end

    // Negative edge triggered flip-flop with conditional update
    always @(negedge clk) begin
        if (d != d_prev) begin  // Only update if input changed
            q_neg <= d;
        end
    end

    // Combinational output selection
    assign q = clk ? q_pos : q_neg;

endmodule