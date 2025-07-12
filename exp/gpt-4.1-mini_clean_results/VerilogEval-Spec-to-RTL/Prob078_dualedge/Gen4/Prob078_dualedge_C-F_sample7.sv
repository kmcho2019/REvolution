module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input wire clk,
    input wire d,
    output reg q
);
    generate
        if (EDGE) begin : pos_edge
            always @(posedge clk) begin
                q <= d;
            end
        end else begin : neg_edge
            always @(negedge clk) begin
                q <= d;
            end
        end
    endgenerate
endmodule

module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    wire q_posedge, q_negedge;

    // Instantiate positive edge FF
    EdgeFF #(.EDGE(1)) pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Instantiate negative edge FF
    EdgeFF #(.EDGE(0)) neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Continuous mux selecting sampled data based on clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule