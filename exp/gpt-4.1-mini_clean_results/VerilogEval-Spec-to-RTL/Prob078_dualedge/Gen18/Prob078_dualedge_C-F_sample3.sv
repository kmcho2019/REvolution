module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input  wire clk,
    input  wire d,
    output reg  q
);
    generate
        if (EDGE) begin : POS
            always @(posedge clk) q <= d;
        end else begin : NEG
            always @(negedge clk) q <= d;
        end
    endgenerate
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    wire q_posedge, q_negedge;

    // Positive edge triggered flip-flop
    EdgeFF #(.EDGE(1)) pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative edge triggered flip-flop
    EdgeFF #(.EDGE(0)) neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Transparent latch-based mux controlled by clock level.
    // When clk=1, q follows q_posedge; when clk=0, q follows q_negedge.
    // This reduces glitches on output compared to a continuous assignment mux.
    always @(clk or q_posedge or q_negedge) begin
        if (clk)
            q = q_posedge;
        else
            q = q_negedge;
    end

endmodule