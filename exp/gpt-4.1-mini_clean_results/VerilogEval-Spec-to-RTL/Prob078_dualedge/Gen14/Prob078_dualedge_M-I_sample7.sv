module PosEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    // Positive edge triggered flip-flop capturing input d
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    // Negative edge triggered flip-flop capturing input d
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
    reg selector;

    // Instantiate positive edge triggered flip-flop
    PosEdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative edge triggered flip-flop
    NegEdgeFF u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Selector toggles on every clock edge (posedge or negedge)
    // to choose which flip-flop output to latch.
    always @(posedge clk or negedge clk) begin
        selector <= ~selector;
    end

    // Output register updated on every clock edge based on selector
    // Output q samples q_pos or q_neg alternately on each clock edge,
    // ensuring output changes only on clock edges, avoiding latch transparency.
    always @(posedge clk or negedge clk) begin
        if (selector)
            q <= q_pos;
        else
            q <= q_neg;
    end

endmodule