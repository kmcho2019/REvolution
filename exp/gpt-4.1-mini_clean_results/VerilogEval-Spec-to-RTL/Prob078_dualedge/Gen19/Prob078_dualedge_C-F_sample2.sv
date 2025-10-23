module PosEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Positive edge triggered flip-flop capturing input d
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Negative edge triggered flip-flop capturing input d
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    wire q_pos, q_neg;
    reg  q_mux;

    // Instantiate positive-edge triggered flip-flop
    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative-edge triggered flip-flop
    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Combinational mux selecting sampled data based on clk level
    always @(*) begin
        q_mux = clk ? q_pos : q_neg;
    end

    // Output flip-flop updates only on positive edge, holding stable output q
    // This avoids glitches and timing issues from combinational or transparent latch outputs,
    // and provides a clean registered output reflecting dual-edge data sampling
    always @(posedge clk) begin
        q <= q_mux;
    end

endmodule