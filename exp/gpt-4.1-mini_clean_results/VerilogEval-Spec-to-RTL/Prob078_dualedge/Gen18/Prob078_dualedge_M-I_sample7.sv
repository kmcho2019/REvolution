module EdgeFFPos (
    input  clk,
    input  d,
    output reg q
);
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module EdgeFFNeg (
    input  clk,
    input  d,
    output reg q
);
    // Negative edge-triggered flip-flop
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  d,
    output reg q
);
    wire q_pos;
    wire q_neg;
    reg  sel; // selector for output, toggles at each clock edge

    // Instantiate positive and negative edge flip-flops
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

    // Selector toggles on both edges to select which flip-flop output to propagate
    always @(posedge clk or negedge clk) begin
        sel <= ~sel;
    end

    // Update output q based on sel synchronized to clock edges
    always @(posedge clk or negedge clk) begin
        if (sel)
            q <= q_pos;
        else
            q <= q_neg;
    end

    // Initialize sel to zero for known startup state
    initial sel = 0;

endmodule