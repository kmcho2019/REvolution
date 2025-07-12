module PosEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  d,
    output reg q
);

    wire q_pos, q_neg;

    // Instantiate positive-edge triggered flip-flop
    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative-edge triggered flip-flop
    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Transparent latch selecting between q_pos and q_neg outputs,
    // controlled by clock level to reduce glitches and power consumption:
    //
    // When clk=1: latch transparent, output follows q_pos.
    // When clk=0: latch transparent, output follows q_neg.
    //
    // This is a level-sensitive latch controlled directly by clk.
    always @(clk or q_pos or q_neg) begin
        if (clk)
            q <= q_pos;
        else
            q <= q_neg;
    end

endmodule