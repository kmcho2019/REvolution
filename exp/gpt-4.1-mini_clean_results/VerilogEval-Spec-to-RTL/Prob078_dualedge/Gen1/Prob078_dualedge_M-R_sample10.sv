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

module TopModule(
    input clk,
    input d,
    output q
);

wire q_rising, q_falling;

EdgeFF u_pos_ff (
    .clk(clk),
    .d(d),
    .q(q_rising)
);

EdgeFFNeg u_neg_ff (
    .clk(clk),
    .d(d),
    .q(q_falling)
);

// Multiplex output based on clk level using continuous assignment
assign q = clk ? q_rising : q_falling;

endmodule