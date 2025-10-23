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
    reg  q_negedge_reg;

    // Positive edge triggered FF sampling input d
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative edge triggered FF sampling input d
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Register negedge sample at posedge clock to align data samples and avoid latch
    always @(posedge clk) begin
        q_negedge_reg <= q_negedge;
    end

    // On each posedge clock, select data from either posedge sample or negedge sample stored from last negedge
    // Effectively emulating dual-edge triggering with a mux and single clock domain register
    always @(posedge clk) begin
        q <= q_posedge | q_negedge_reg;  // OR merges both sampled inputs to get latest data
        // Alternatively, if strict data selection per edge is needed:
        // q <= q_posedge; // or a custom mux can be used for other logic
    end

endmodule