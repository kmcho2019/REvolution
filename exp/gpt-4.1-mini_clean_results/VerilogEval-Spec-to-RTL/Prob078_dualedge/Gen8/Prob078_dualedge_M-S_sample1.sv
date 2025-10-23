module TopModule (
    input  clk,
    input  d,
    output q
);
    reg q_pos, q_neg;

    // Positive-edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative-edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output selects q_pos when clk=1, else q_neg
    assign q = clk ? q_pos : q_neg;

endmodule