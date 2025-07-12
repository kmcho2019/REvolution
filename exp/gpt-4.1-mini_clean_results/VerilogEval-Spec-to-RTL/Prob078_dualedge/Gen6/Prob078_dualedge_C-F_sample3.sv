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

module NegEdgeFF (
    input  clk,
    input  d,
    output reg q
);
    // Negative edge triggered flip-flop capturing input d
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  d,
    output reg q
);

    wire q_pos, q_neg;

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

    // Output latch controlled by clock level:
    // When clk=1, latch passes q_pos;
    // When clk=0, latch holds q_neg.
    // This reduces glitches compared to combinational mux on clk.
    reg q_latch;
    always @(clk or q_pos or q_neg) begin
        if (clk)
            q_latch <= q_pos;
        else
            q_latch <= q_neg;
    end

    // Drive output q with latch output
    always @(posedge clk or negedge clk) begin
        q <= q_latch;
    end

endmodule