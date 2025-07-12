module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Single-edge triggered flip-flop parameterized by EDGE
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
    wire q_posedge, q_negedge;

    // Positive edge triggered FF captures data on rising edge
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative edge triggered FF captures data on falling edge
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Output mux chooses between posedge and negedge FF outputs based on clock level
    // This mux is implemented as a continuous assignment to avoid glitches
    assign q = clk ? q_posedge : q_negedge;

endmodule