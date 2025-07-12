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
    output reg  q
);

    wire q_posedge, q_negedge;

    // Instantiate positive-edge triggered flip-flop
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Instantiate negative-edge triggered flip-flop
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Transparent latch controlled by clock level to reduce glitches and switching power:
    // When clk = 1, latch is transparent and follows q_posedge.
    // When clk = 0, latch is transparent and follows q_negedge.
    // Use non-blocking assignments and include q signals in sensitivity list for synthesis friendliness.
    always @(clk or q_posedge or q_negedge) begin
        if (clk)
            q <= q_posedge;
        else
            q <= q_negedge;
    end

endmodule