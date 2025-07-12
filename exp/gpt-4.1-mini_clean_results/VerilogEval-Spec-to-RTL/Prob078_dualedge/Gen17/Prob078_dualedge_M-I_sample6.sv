module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
) (
    input clk,
    input d,
    output reg q
);
    generate
        if (EDGE) begin : pos_edge_ff
            always @(posedge clk) begin
                q <= d;
            end
        end else begin : neg_edge_ff
            always @(negedge clk) begin
                q <= d;
            end
        end
    endgenerate
endmodule

module TopModule (
    input clk,
    input d,
    output reg q
);

    wire q_pos;
    wire q_neg;
    wire q_mux;

    // Positive-edge triggered FF
    EdgeFF #(.EDGE(1)) u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Negative-edge triggered FF
    EdgeFF #(.EDGE(0)) u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Combinational mux to select output from either FF based on clk level
    assign q_mux = clk ? q_pos : q_neg;

    // Registered output stage clocked on posedge clk to reduce glitches and improve timing
    always @(posedge clk) begin
        q <= q_mux;
    end

endmodule