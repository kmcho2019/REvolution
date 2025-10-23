module TopModule (
    input clk,
    input d,
    output q
);

    // Clear naming for edge-triggered storage elements
    reg q_pos;  // Positive edge capture
    reg q_neg;  // Negative edge capture

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Efficient clock-based output selection
    assign q = clk ? q_pos : q_neg;

endmodule