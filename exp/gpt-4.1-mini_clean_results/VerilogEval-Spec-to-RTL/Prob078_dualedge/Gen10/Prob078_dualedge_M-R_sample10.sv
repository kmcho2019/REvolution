module TransparentLatch (
    input d,
    input en,
    output reg q
);
    // Level-sensitive transparent latch:
    // When en=1, q follows d; when en=0, q holds previous value.
    always @(*) begin
        if (en)
            q = d;
        else
            q = q; // hold
    end
endmodule

module EdgeFFPos (
    input clk,
    input d,
    output reg q
);
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module EdgeFFNeg (
    input clk,
    input d,
    output reg q
);
    // Negative edge-triggered flip-flop
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output q
);
    wire q_pos, q_neg;
    wire latch_pos_q, latch_neg_q;

    // Two flip-flops capturing data on posedge and negedge of clk
    EdgeFFPos u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    EdgeFFNeg u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Two transparent latches:
    // - latch_pos is transparent when clk=1, samples q_pos
    // - latch_neg is transparent when clk=0, samples q_neg
    TransparentLatch latch_pos (
        .d(q_pos),
        .en(clk),
        .q(latch_pos_q)
    );

    TransparentLatch latch_neg (
        .d(q_neg),
        .en(~clk),
        .q(latch_neg_q)
    );

    // Output mux selects latch output based on clk
    assign q = clk ? latch_pos_q : latch_neg_q;

endmodule