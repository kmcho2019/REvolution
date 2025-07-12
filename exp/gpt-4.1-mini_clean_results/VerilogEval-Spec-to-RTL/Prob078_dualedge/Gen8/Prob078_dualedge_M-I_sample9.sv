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
    reg mux_sel;

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

    // Synchronize clk level to mux_sel signal using a flip-flop clocked on posedge
    // This makes the mux select signal change only on posedge clk, avoiding glitching on output mux
    always @(posedge clk) begin
        mux_sel <= clk;
    end

    // Output mux with synchronous select signal
    assign q = mux_sel ? q_posedge : q_negedge;

endmodule