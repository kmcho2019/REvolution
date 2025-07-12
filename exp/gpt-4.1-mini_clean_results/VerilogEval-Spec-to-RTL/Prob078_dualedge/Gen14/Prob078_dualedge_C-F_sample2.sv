module PosEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TransparentLatch (
    input  wire en,
    input  wire d0,
    input  wire d1,
    output reg  q
);
    // Transparent latch:
    // When enable 'en' = 1, latch output follows d1
    // When enable 'en' = 0, latch output follows d0
    //
    // Non-blocking assignment to better model latch timing.
    // Sensitivity list includes en, d0, d1 for combinational transparency.
    always @(en or d0 or d1) begin
        if (en)
            q <= d1;
        else
            q <= d0;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    wire q_pos, q_neg;
    wire q_latch;

    // Positive-edge triggered flip-flop
    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Negative-edge triggered flip-flop
    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Transparent latch as output mux controlled by clk level:
    // clk=1 selects q_pos; clk=0 selects q_neg
    // This latch ensures glitch-free output transitions.
    TransparentLatch latch_mux (
        .en(clk),
        .d0(q_neg),
        .d1(q_pos),
        .q(q_latch)
    );

    assign q = q_latch;

endmodule