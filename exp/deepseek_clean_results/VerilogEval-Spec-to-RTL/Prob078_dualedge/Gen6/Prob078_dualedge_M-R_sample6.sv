module TopModule (
    input clk,
    input d,
    output q
);

    wire q_pos, q_neg;
    reg q_pos_reg, q_neg_reg;

    // Positive edge triggered flip-flop using continuous assignment
    assign q_pos = q_pos_reg;
    always @(posedge clk) q_pos_reg <= d;

    // Negative edge triggered flip-flop using continuous assignment
    assign q_neg = q_neg_reg;
    always @(negedge clk) q_neg_reg <= d;

    // Explicit output selection mux
    assign q = clk ? q_pos : q_neg;

endmodule