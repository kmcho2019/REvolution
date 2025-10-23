module TopModule (
    input clk,
    input d,
    output q
);

    // Storage elements for both clock edges
    reg q_pos;  // Positive edge triggered FF
    reg q_neg;  // Negative edge triggered FF
    reg d_prev; // Previous input value for stability detection

    // Input stability detection
    always @(posedge clk) begin
        d_prev <= d;
    end

    // Positive edge capture with conditional update
    always @(posedge clk) begin
        if (d != d_prev) begin
            q_pos <= d;
        end
    end

    // Negative edge capture with conditional update
    always @(negedge clk) begin
        if (d != d_prev) begin
            q_neg <= d;
        end
    end

    // Optimized output selection
    assign q = clk ? q_pos : q_neg;

endmodule