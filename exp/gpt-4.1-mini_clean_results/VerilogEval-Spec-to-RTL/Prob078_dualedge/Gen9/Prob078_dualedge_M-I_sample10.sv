module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos;
    reg q_neg;
    reg clk_d;  // delayed version of clk for mux select

    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
        clk_d <= clk;
    end

    // Negative edge-triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Use registered clk_d for mux select to reduce glitches and improve timing
    assign q = clk_d ? q_pos : q_neg;

endmodule