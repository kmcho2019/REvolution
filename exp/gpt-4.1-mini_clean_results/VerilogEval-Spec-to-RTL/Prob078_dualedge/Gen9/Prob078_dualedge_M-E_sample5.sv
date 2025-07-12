module PosEdgeFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_bar = ~clk;
    wire q_pos;
    wire q_neg;

    // Flip-flop sampling d on positive edge of clk
    PosEdgeFF ff_pos (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Flip-flop sampling d on positive edge of clk_bar (i.e., negative edge of clk)
    PosEdgeFF ff_neg (
        .clk(clk_bar),
        .d(d),
        .q(q_neg)
    );

    // Multiplexer selects q_pos when clk=1, q_neg when clk=0
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule