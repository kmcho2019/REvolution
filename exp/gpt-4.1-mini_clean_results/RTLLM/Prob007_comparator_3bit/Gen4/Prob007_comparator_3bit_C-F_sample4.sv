module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality detection via XOR reduction: if any bit differs, XOR reduction is 1; invert it to get equality
    wire eq = ~( |(A ^ B) );

    // Use direct relational operator for greater-than comparison (simple and efficient)
    wire gt = (A > B);

    assign A_equal   = eq;
    assign A_greater = gt;
    assign A_less    = ~gt & ~eq;

endmodule