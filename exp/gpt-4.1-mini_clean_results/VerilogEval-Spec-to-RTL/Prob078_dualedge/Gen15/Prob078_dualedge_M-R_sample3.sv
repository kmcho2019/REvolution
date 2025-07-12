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

    // Positive edge flip-flop
    EdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Negative edge flip-flop
    EdgeFFNeg neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Output selects the flip-flop output corresponding to clk level
    assign q = clk ? q_pos : q_neg;

endmodule