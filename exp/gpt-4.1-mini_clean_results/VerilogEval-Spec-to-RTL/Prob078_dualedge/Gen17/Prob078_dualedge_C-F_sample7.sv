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
    reg mux_out;

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

    // Mux output: combinationally select q_pos or q_neg based on clock level
    // This mux output drives a register clocked at posedge clk for glitch-free stable output
    always @(*) begin
        mux_out = clk ? q_pos : q_neg;
    end

    // Output register samples mux output at posedge clk, stabilizing output and reducing glitches
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule