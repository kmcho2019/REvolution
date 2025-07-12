module TopModule (
    input  clk,
    input  d,
    output q
);
    reg q_pos;
    reg q_neg;

    // Positive-edge triggered register capturing d
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative-edge triggered register capturing d
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output selects data from posedge or negedge register based on clock level
    assign q = clk ? q_pos : q_neg;

endmodule