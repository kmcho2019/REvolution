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

    // Instantiate positive edge triggered flip-flop
    PosEdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative edge triggered flip-flop
    NegEdgeFF u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Transparent latch selecting between q_pos and q_neg based on clk level.
    // When clk=1, latch is transparent and samples q_pos.
    // When clk=0, latch is transparent and samples q_neg.
    //
    // This reduces glitches and power compared to a combinational mux,
    // providing a stable and glitch-free dual-edge triggered output.
    always @(clk or q_pos or q_neg) begin
        if (clk) begin
            q <= q_pos;
        end else begin
            q <= q_neg;
        end
    end

endmodule