module TopModule (
    input clk,
    input d,
    output q
);

    // Edge-triggered storage elements
    reg q_pos;  // Captures data on rising edge
    reg q_neg;  // Captures data on falling edge

    // Positive edge behavior
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge behavior
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Phase-correct output selection
    assign q = clk ? q_pos : q_neg;

endmodule