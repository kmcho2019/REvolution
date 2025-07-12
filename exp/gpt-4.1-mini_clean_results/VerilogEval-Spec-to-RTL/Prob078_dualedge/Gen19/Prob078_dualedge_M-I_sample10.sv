module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input wire clk,
    input wire d,
    output reg q
);
    generate
        if (EDGE) begin : POS_EDGE_FF
            always @(posedge clk) begin
                q <= d;
            end
        end else begin : NEG_EDGE_FF
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

    // Positive edge triggered FF
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative edge triggered FF (standard)
    // Note: To reduce toggling, we could consider gating clock or data.
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Multiplex output based on clk level to emulate dual-edge triggering
    assign q = clk ? q_posedge : q_negedge;

endmodule