module EdgeFF_pos (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module EdgeFF_neg (
    input wire clk,
    input wire d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    wire q_posedge, q_negedge;

    // Positive-edge triggered flip-flop
    EdgeFF_pos ff_pos (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Negative-edge triggered flip-flop
    EdgeFF_neg ff_neg (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Multiplexer selecting flip-flop output based on clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule