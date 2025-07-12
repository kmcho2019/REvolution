module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input  wire clk,
    input  wire d,
    output reg  q
);
    generate
        if (EDGE) begin
            always @(posedge clk) q <= d;
        end else begin
            always @(negedge clk) q <= d;
        end
    endgenerate
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    wire q_posedge, q_negedge;

    EdgeFF #(.EDGE(1)) pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    EdgeFF #(.EDGE(0)) neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Simple mux selects output based on clock level:
    // clk=1 -> q_posedge, clk=0 -> q_negedge
    assign q = clk ? q_posedge : q_negedge;

endmodule