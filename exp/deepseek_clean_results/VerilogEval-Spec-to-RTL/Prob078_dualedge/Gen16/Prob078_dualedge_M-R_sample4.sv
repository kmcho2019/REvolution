module TopModule (
    input clk,
    input d,
    output q
);

    reg clk_prev;
    wire pos_edge = clk & ~clk_prev;
    wire neg_edge = ~clk & clk_prev;

    reg q_pos, q_neg;

    always @* begin
        if (pos_edge) q_pos = d;
        if (neg_edge) q_neg = d;
        clk_prev = clk;
    end

    assign q = clk ? q_pos : q_neg;

endmodule