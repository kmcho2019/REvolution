module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire eq = (A == B);
    wire gt = (A > B);

    assign A_equal   = eq;
    assign A_greater = ~eq & gt;
    assign A_less    = ~eq & ~gt;

endmodule