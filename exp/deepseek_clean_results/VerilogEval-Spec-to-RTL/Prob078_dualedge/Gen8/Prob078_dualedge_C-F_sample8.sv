module TopModule (
    input clk,
    input d,
    output q
);

    reg pos_ff, neg_ff;

    // Positive edge capture
    always @(posedge clk) begin
        pos_ff <= d;
    end

    // Negative edge capture
    always @(negedge clk) begin
        neg_ff <= d;
    end

    // Clock-driven output selection
    assign q = clk ? pos_ff : neg_ff;

endmodule