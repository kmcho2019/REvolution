module PosEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    wire q_posedge, q_negedge;

    // Positive-edge triggered flip-flop instance
    PosEdgeFF u_posedge_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative-edge triggered flip-flop instance
    NegEdgeFF u_negedge_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Transparent latch controlled by clk level to reduce glitches:
    // When clk=1, latch passes q_posedge; when clk=0, passes q_negedge.
    // Use blocking assignments to model latch behavior, which is more natural and synthesis-friendly.
    always @(clk or q_posedge or q_negedge) begin
        if (clk)
            q = q_posedge;
        else
            q = q_negedge;
    end
endmodule