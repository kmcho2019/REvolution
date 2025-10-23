module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos = 0, q_neg = 0;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output selection based on clock state
    assign q = clk ? q_pos : q_neg;

endmodule