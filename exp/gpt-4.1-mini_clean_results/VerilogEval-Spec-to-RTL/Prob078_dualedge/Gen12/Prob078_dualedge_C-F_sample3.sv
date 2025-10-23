module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input  wire clk,
    input  wire d,
    output reg  q
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

    // Positive-edge triggered flip-flop sampling d
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative-edge triggered flip-flop sampling d
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Transparent latch controlled by clk level:
    // When clk=1, latch passes q_posedge;
    // When clk=0, latch passes q_negedge.
    // Blocking assignments used to describe latch behavior.
    always @(clk or q_posedge or q_negedge) begin
        if (clk)
            q = q_posedge;
        else
            q = q_negedge;
    end

endmodule