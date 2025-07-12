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
    input  wire clk,
    input  wire d,
    output reg  q
);

    wire q_posedge, q_negedge;

    // Instantiate positive-edge triggered flip-flop
    EdgeFF #(.EDGE(1)) pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Instantiate negative-edge triggered flip-flop
    EdgeFF #(.EDGE(0)) neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Transparent latch controlled by clk level:
    // - When clk=1, q follows q_posedge (latch transparent)
    // - When clk=0, q follows q_negedge (latch transparent)
    //
    // This reduces glitches and switching power compared to combinational mux.
    always @(clk or q_posedge or q_negedge) begin
        if (clk)
            q <= q_posedge;
        else
            q <= q_negedge;
    end

endmodule