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
    reg  q_negedge_sync1, q_negedge_sync2;

    // Positive edge triggered flip-flop sampling d
    EdgeFF #(.EDGE(1)) pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative edge triggered flip-flop sampling d
    EdgeFF #(.EDGE(0)) neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Synchronize negedge FF output into posedge clock domain
    always @(posedge clk) begin
        q_negedge_sync1 <= q_negedge;
        q_negedge_sync2 <= q_negedge_sync1;
    end

    // Use a one-cycle delayed clock signal to select between posedge and negedge sampled data
    // Delayed clock (clk_dly) toggles one cycle behind clk
    reg clk_dly;
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // Mux selects q_negedge_sync2 when clk_dly=0 (was low previous cycle),
    // else q_posedge when clk_dly=1
    assign q = clk_dly ? q_posedge : q_negedge_sync2;

endmodule