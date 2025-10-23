module EdgeFF (
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
    EdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    EdgeFFNeg u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Output transparent latch controlled by clk:
    // When clk is high, latch transparent and captures q_pos
    // When clk is low, latch transparent and captures q_neg
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule