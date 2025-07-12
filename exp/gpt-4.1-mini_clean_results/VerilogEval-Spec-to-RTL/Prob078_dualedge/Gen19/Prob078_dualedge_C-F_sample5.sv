module PosEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Negative edge-triggered flip-flop
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

    // Instantiate flip-flops clocked on opposite edges
    PosEdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    NegEdgeFF u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Combinational 2-to-1 mux selects output based on clock level
    assign q = clk ? q_pos : q_neg;

endmodule