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

    // Two edge-triggered flip-flops capturing data on posedge and negedge of clk
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

    // Transparent latch selecting between q_pos and q_neg outputs,
    // controlled by clk level to reduce glitches and power:
    //
    // When clk is high, latch is transparent and samples q_pos,
    // when clk is low, latch is transparent and samples q_neg.
    //
    // The latch is implemented with level-sensitive behavior on clk.
    always @(clk or q_pos or q_neg) begin
        if (clk) begin
            q <= q_pos;
        end else begin
            q <= q_neg;
        end
    end

endmodule