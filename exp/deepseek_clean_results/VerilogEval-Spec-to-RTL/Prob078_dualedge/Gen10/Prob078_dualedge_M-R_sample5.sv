module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;

    assign q = clk ? (q_pos <= d) : (q_neg <= d);

endmodule