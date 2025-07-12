module DualEdgeSampler (
    input clk,
    input d,
    output reg q_pos,
    output reg q_neg
);
    // Sample input d on positive edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Sample input d on negative edge
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

    // Instantiate the dual-edge data sampler
    DualEdgeSampler sampler (
        .clk(clk),
        .d(d),
        .q_pos(q_pos),
        .q_neg(q_neg)
    );

    // Output mux selects sampled data based on clk level
    assign q = clk ? q_pos : q_neg;

endmodule