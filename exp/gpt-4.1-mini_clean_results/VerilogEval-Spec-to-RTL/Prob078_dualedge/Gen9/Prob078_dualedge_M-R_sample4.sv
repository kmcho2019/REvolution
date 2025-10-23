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
    output reg q
);

    wire q_pos;
    wire q_neg;
    reg  latch_out;

    // Instantiate positive and negative edge-triggered flip-flops
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

    // Transparent latch enable signals derived from clock level
    wire latch_en_pos = clk;      // latch transparent when clk=1
    wire latch_en_neg = ~clk;     // latch transparent when clk=0

    // Transparent latch implementation:
    // When latch_en_pos is high, latch samples q_pos
    // When latch_en_neg is high, latch samples q_neg
    always @(*) begin
        if (latch_en_pos)
            latch_out = q_pos;
        else
            latch_out = q_neg;
    end

    // Register output to avoid glitches; updates on both edges by design since latch_out follows clk level
    always @(posedge clk or negedge clk) begin
        q <= latch_out;
    end

endmodule