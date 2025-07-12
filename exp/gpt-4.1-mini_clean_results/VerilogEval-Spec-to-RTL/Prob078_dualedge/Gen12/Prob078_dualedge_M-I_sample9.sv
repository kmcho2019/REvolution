module PosEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    // Positive edge triggered flip-flop capturing input d
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegLevelLatch (
    input clk,
    input d,
    output reg q
);
    // Negative-level transparent latch: transparent when clk=0
    always @(clk or d) begin
        if (clk == 1'b0)
            q = d;  // transparent when clk=0
        // else hold value
    end
endmodule

module TopModule (
    input  clk,
    input  d,
    output q
);
    wire ff_q;
    wire latch_q;

    // Positive edge triggered flip-flop
    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(ff_q)
    );

    // Negative level latch transparent when clk=0
    NegLevelLatch neg_latch (
        .clk(clk),
        .d(d),
        .q(latch_q)
    );

    // Mux output: latch output during clk=0, flip-flop output during clk=1
    assign q = clk ? ff_q : latch_q;

endmodule