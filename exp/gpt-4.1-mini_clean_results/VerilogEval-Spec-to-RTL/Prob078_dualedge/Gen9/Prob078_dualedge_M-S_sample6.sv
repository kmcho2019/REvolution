module EdgeFFPos (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module EdgeFFNeg (
    input clk,
    input d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output q
);
    wire q_pos, q_neg;

    EdgeFFPos ff_pos (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    EdgeFFNeg ff_neg (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Combinational multiplexer selects output based on clk level
    assign q = clk ? q_pos : q_neg;

endmodule