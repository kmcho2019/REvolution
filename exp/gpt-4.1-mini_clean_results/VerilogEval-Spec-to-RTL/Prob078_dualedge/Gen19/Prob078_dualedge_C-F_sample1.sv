module EdgeFF #(
    parameter EDGE = 1'b1 // 1 for posedge, 0 for negedge
)(
    input  wire clk,
    input  wire d,
    output reg  q
);
    generate
        if (EDGE) begin : pos_edge_ff
            always @(posedge clk) begin
                q <= d;
            end
        end else begin : neg_edge_ff
            always @(negedge clk) begin
                q <= d;
            end
        end
    endgenerate
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    wire q_pos, q_neg;

    // Instantiate positive-edge triggered flip-flop
    EdgeFF #(.EDGE(1'b1)) pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative-edge triggered flip-flop
    EdgeFF #(.EDGE(1'b0)) neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Multiplex output based on clock level (no latch)
    assign q = clk ? q_pos : q_neg;

endmodule