module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg q_pos;
    reg q_neg;

    // Positive edge flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output register clocked on posedge clk to select between q_pos and q_neg
    always @(posedge clk) begin
        // When clk=1, output q_pos (just updated)
        // When clk=0 (previous clk state), output q_neg (updated at negedge)
        q <= clk ? q_pos : q_neg;
    end

endmodule