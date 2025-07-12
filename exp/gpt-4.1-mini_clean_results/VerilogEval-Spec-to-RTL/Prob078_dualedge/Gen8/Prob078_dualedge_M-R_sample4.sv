module EdgeFFPos (
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
    wire mux_out;

    // Instantiate positive-edge flip-flop
    EdgeFFPos u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative-edge flip-flop
    EdgeFFNeg u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Combinational mux selecting q_pos or q_neg based on clock level
    assign mux_out = clk ? q_pos : q_neg;

    // Register the mux output to reduce glitches and synchronize output
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule