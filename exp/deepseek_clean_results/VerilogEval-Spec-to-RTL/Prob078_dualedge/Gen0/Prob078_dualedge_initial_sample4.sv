module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Mux to select between the two flip-flops based on clock state
    assign q = clk ? q_neg : q_pos;

endmodule