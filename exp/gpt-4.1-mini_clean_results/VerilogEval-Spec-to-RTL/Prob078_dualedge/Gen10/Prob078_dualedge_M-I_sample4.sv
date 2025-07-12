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
    reg q_selected;

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

    // On posedge clk, latch q_posedge; on negedge clk, latch q_negedge
    always @(posedge clk or negedge clk) begin
        if (clk)
            q_selected <= q_posedge;
        else
            q_selected <= q_negedge;
    end

    // Output register driven on posedge clk for stable output, reducing glitch risk
    always @(posedge clk) begin
        q <= q_selected;
    end

endmodule