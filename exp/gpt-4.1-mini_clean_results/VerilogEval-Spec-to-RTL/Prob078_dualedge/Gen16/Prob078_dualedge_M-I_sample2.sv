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

    // Phase toggles every half clk period, synchronized to clk posedge
    reg phase;
    always @(posedge clk) begin
        phase <= ~phase;
    end

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

    // Synchronize mux output with clk to avoid glitches and reduce timing path
    always @(posedge clk) begin
        if (phase)
            q <= q_posedge;
        else
            q <= q_negedge;
    end

endmodule