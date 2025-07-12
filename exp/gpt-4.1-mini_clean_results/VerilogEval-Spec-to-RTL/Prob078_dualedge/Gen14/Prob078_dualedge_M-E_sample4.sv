module pos_edge_ff (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module neg_edge_ff (
    input wire clk,
    input wire d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input wire clk,
    input wire d,
    output reg q
);

    wire q_pos, q_neg;

    // Sample input on positive edge
    pos_edge_ff ff_pos (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Sample input on negative edge
    neg_edge_ff ff_neg (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Update output on positive edge of clk with muxed data
    always @(posedge clk) begin
        if (clk)
            q <= q_pos;  // when clk high, use positive edge sample
        else
            q <= q_neg;  // when clk low, use negative edge sample (stable as clk just rose)
    end

endmodule