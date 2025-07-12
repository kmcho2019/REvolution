module TopModule (
    input clk,
    input d,
    output q
);

    reg pos_q, neg_q;

    // Positive edge capture
    always @(posedge clk) begin
        pos_q <= d;
    end

    // Negative edge capture (direct sensitivity)
    always @(negedge clk) begin
        neg_q <= d;
    end

    // Clock-based output selection
    assign q = clk ? pos_q : neg_q;

endmodule