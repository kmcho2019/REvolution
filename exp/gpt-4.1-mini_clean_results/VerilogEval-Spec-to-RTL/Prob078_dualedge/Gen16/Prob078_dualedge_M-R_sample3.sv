module DualEdgeSample (
    input clk,
    input d,
    output reg q_pos,
    output reg q_neg
);
    // Sample d at rising edge
    always @(posedge clk) begin
        q_pos <= d;
    end
    // Sample d at falling edge
    always @(negedge clk) begin
        q_neg <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output q
);
    wire q_pos, q_neg;

    DualEdgeSample sampler (
        .clk(clk),
        .d(d),
        .q_pos(q_pos),
        .q_neg(q_neg)
    );

    // Output q selects the sampled data depending on clock level
    assign q = clk ? q_pos : q_neg;
endmodule