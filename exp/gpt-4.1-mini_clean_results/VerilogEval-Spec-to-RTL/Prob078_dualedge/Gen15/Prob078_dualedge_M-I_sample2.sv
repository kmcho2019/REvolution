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
    output reg q
);

    wire q_posedge, q_negedge;

    // Sample data on positive edge
    EdgeFF #(.EDGE(1)) pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Sample data on negative edge
    EdgeFF #(.EDGE(0)) neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Register output mux to reduce glitches and timing critical path
    // Select between posedge and negedge sampled data based on clk level
    always @(posedge clk) begin
        if (clk)
            q <= q_posedge;
        else
            q <= q_negedge;
    end

endmodule