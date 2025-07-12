module DualEdgeSampler (
    input  wire clk,
    input  wire d,
    output reg  q_pos,
    output reg  q_neg
);
    // Sample 'd' at positive clock edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Sample 'd' at negative clock edge
    always @(negedge clk) begin
        q_neg <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    reg q_pos, q_neg;

    // Instantiate the internal dual-edge sampler
    DualEdgeSampler sampler (
        .clk(clk),
        .d(d),
        .q_pos(q_pos),
        .q_neg(q_neg)
    );

    // Multiplex output based on current clock level
    assign q = clk ? q_pos : q_neg;

endmodule