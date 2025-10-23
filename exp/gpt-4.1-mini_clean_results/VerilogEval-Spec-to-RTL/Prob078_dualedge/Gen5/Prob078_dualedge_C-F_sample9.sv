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
    reg clk_d1;

    // Instantiate positive-edge triggered flip-flop
    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative-edge triggered flip-flop
    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Register the current clock level (clk_d1) on positive edge clk
    // This is a stable, glitch-free delayed version of clk used as mux select
    always @(posedge clk) begin
        clk_d1 <= clk;
    end

    // Combinational mux selects between q_pos and q_neg based on registered clk level
    wire mux_out = clk_d1 ? q_pos : q_neg;

    // Register the mux output on posedge clk to stabilize output and reduce glitches
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule