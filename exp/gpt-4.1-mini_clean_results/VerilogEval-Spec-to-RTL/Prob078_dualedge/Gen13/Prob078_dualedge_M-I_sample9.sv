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
    output wire q
);

    wire q_posedge, q_negedge;
    wire mux_out;

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

    // Mux selects sampled data based on clock level (combinational)
    assign mux_out = clk ? q_posedge : q_negedge;

    // Register mux output to reduce glitches and improve timing
    reg q_reg;
    always @(posedge clk) begin
        q_reg <= mux_out;
    end

    assign q = q_reg;

endmodule