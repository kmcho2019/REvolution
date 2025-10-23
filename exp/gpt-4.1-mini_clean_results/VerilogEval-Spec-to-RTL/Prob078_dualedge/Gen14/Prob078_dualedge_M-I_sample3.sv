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
    reg select_q_pos;

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

    // On each positive edge of clk, latch the clock level to select output source
    always @(posedge clk) begin
        select_q_pos <= clk;
    end

    // Output register to avoid glitches and hold the selected output
    always @(posedge clk) begin
        if (select_q_pos)
            q <= q_pos;
        else
            q <= q_neg;
    end

endmodule