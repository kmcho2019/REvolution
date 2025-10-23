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
    wire mux_out;

    // Positive-edge triggered FF sampling input d
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative-edge triggered FF sampling input d
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Combinational mux selects sampled data based on clk level
    assign mux_out = clk ? q_posedge : q_negedge;

    // Register output on posedge clk to reduce glitches and break combinational path
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule