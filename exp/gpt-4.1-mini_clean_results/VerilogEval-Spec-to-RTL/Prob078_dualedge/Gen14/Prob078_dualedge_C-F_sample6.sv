module PosEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    wire q_pos, q_neg;

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

    // Output muxed continuously by clock level to emulate dual-edge triggering
    assign q = clk ? q_pos : q_neg;

endmodule