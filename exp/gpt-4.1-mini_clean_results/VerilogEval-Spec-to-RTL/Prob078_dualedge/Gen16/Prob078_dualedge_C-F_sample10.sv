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

    // Instantiate positive edge triggered flip-flop
    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative edge triggered flip-flop
    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Clock-level controlled transparent latch to select output
    // When clk = 1, latch is transparent and passes q_pos.
    // When clk = 0, latch is transparent and passes q_neg.
    // This latch-based mux reduces glitches and switching activity compared to a combinational mux.
    always @(clk or q_pos or q_neg) begin
        if (clk) begin
            q <= q_pos;
        end else begin
            q <= q_neg;
        end
    end

endmodule