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
    output reg q
);
    wire q_pos, q_neg;
    reg q_int;

    DualEdgeSample sampler (
        .clk(clk),
        .d(d),
        .q_pos(q_pos),
        .q_neg(q_neg)
    );

    // On rising edge, select sample based on clk level before posedge:
    // Since clk is stable at posedge, this effectively picks q_pos when clk=1, q_neg when clk=0.
    always @(posedge clk) begin
        q <= clk ? q_pos : q_neg;
    end
endmodule