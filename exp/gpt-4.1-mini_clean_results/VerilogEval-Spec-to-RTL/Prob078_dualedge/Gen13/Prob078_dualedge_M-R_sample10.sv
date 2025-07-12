module PosEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TransparentLatch (
    input  en,      // latch enable (level sensitive)
    input  d,
    output reg q
);
    always @(en or d) begin
        if (en)
            q <= d;
        // else hold state (no update)
    end
endmodule

module TopModule (
    input  clk,
    input  d,
    output q
);

    wire q_pos, q_neg;
    wire latch_out_high, latch_out_low;

    // Positive edge flip-flop
    PosEdgeFF ff_pos (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Negative edge flip-flop
    NegEdgeFF ff_neg (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Two transparent latches controlled by clk and its complement,
    // each sampling one flip-flop output:
    // - latch_out_high follows q_pos when clk=1 (latch transparent)
    // - latch_out_low follows q_neg when clk=0 (latch transparent)
    TransparentLatch latch_high (
        .en(clk),
        .d(q_pos),
        .q(latch_out_high)
    );

    TransparentLatch latch_low (
        .en(~clk),
        .d(q_neg),
        .q(latch_out_low)
    );

    // Output q is driven by the two latch outputs combined by clk level
    // Using assign ensures q is always driven by the active latch output,
    // avoids glitches and better reflects latch muxing behavior
    assign q = clk ? latch_out_high : latch_out_low;

endmodule