module PosEdgeFF (
    input  clk,
    input  d,
    output reg q_pos
);
    always @(posedge clk) begin
        q_pos <= d;
    end
endmodule

module NegEdgeFF (
    input  clk,
    input  d,
    output reg q_neg
);
    always @(negedge clk) begin
        q_neg <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  d,
    output reg q
);

    wire q_pos, q_neg;
    reg clk_dly;

    // Capture d on positive edge
    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q_pos(q_pos)
    );

    // Capture d on negative edge
    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q_neg(q_neg)
    );

    // Delay clk by one cycle to detect edge transition in always block
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // Update q on positive edge by choosing q_neg (freshly sampled on negedge)
    // This assumes q_neg contains the data sampled on the preceding negative edge,
    // so q updates every positive edge with alternating q_pos/q_neg samples.
    always @(posedge clk) begin
        // If clock was low in previous cycle, use q_neg (neg edge captured data)
        // Else use q_pos (pos edge captured data)
        if (clk_dly == 1'b0)
            q <= q_neg;
        else
            q <= q_pos;
    end

endmodule