module TopModule (
    input clk,
    input d,
    output reg q
);

    // Sequential elements with enable
    reg q_pos;  // Positive edge triggered
    reg q_neg;  // Negative edge triggered
    reg d_prev; // Previous input value

    // Detect input changes
    always @(posedge clk) begin
        d_prev <= d;
    end

    wire input_changed = (d != d_prev);

    // Positive edge triggered flip-flop with enable
    always @(posedge clk) begin
        if (input_changed) q_pos <= d;
    end

    // Negative edge triggered flip-flop with enable
    always @(negedge clk) begin
        if (input_changed) q_neg <= d;
    end

    // Output stage with improved drive strength
    always @(*) begin
        q = clk ? q_pos : q_neg;
    end

endmodule