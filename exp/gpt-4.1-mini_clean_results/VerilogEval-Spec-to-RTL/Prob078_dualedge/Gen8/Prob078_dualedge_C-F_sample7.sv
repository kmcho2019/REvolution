module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input wire clk,
    input wire d,
    output reg q
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
    input wire clk,
    input wire d,
    output wire q
);
    wire q_posedge, q_negedge;

    // Instantiate positive edge triggered FF
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Instantiate negative edge triggered FF
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Continuous assignment mux selecting output based on clock level, glitch-free
    assign q = clk ? q_posedge : q_negedge;

endmodule