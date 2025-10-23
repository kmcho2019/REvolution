module EdgeFFPos (
    input clk,
    input d,
    output reg q
);
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module EdgeFFNeg (
    input clk,
    input d,
    output reg q
);
    // Negative edge-triggered flip-flop
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output reg q
);

    wire q_pos, q_neg;

    // Two flip-flops triggered on positive and negative edges
    EdgeFFPos u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    EdgeFFNeg u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Positive level transparent latch controlled by clk
    // When clk=1, latch is transparent and q follows q_pos
    // When clk=0, latch holds its previous value
    reg latch_out;
    always @(clk or q_pos) begin
        if (clk)
            latch_out <= q_pos;
        // else hold previous value
    end

    // Output driven by latch when clk=1, else q_neg
    // To ensure correct dual edge behavior, update q on clock edges as well
    always @(negedge clk or posedge clk) begin
        if (clk)
            q <= latch_out;   // clk just rose: latch transparent, output q_pos
        else
            q <= q_neg;       // clk just fell: output q_neg
    end

endmodule