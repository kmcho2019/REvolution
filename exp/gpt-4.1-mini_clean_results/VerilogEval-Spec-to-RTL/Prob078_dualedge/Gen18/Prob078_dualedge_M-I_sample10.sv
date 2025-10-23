module EdgeFF #(
    parameter EDGE = 1  // 1 for posedge, 0 for negedge
)(
    input wire clk,
    input wire d,
    output reg q
);
    generate
        if (EDGE) begin : POS_EDGE_FF
            always @(posedge clk) begin
                q <= d;
            end
        end else begin : NEG_EDGE_FF
            always @(posedge clk) begin
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

    wire neg_clk = ~clk;

    wire q_posedge;
    wire q_negedge;

    // Positive edge FF triggered on rising clk
    EdgeFF #(.EDGE(1)) ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative edge FF triggered on rising neg_clk (which is ~clk)
    EdgeFF #(.EDGE(0)) ff_neg (
        .clk(neg_clk),
        .d(d),
        .q(q_negedge)
    );

    reg mux_out;

    // Multiplexer selecting the latest sampled value based on current clk level
    always @(*) begin
        if (clk)
            mux_out = q_posedge;
        else
            mux_out = q_negedge;
    end

    // Register the mux output on rising edge of clk to filter glitches and improve timing
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule