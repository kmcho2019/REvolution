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
    output q
);

    wire q_pos;
    wire q_neg;

    // Instantiate positive-edge triggered flip-flop
    EdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative-edge triggered flip-flop
    EdgeFFNeg u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Output is a mux selecting q_pos when clk is high, q_neg when clk is low
    assign q = clk ? q_pos : q_neg;

endmodule