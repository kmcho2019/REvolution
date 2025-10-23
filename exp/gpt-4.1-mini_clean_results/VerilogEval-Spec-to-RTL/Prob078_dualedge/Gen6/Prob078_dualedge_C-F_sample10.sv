// Positive edge-triggered flip-flop module
module PosEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Negative edge-triggered flip-flop module
module NegEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

// Top-level module emulating dual-edge triggered flip-flop
module TopModule (
    input  clk,
    input  d,
    output q
);

    wire q_posedge;
    wire q_negedge;

    // Instantiate positive-edge triggered flip-flop
    PosEdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Instantiate negative-edge triggered flip-flop
    NegEdgeFF u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Output mux chooses latest sampled data based on clk level
    // When clk is high, output data sampled at posedge
    // When clk is low, output data sampled at negedge
    assign q = clk ? q_posedge : q_negedge;

endmodule