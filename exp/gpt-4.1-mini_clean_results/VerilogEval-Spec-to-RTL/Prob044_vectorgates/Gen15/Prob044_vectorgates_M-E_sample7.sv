module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;

    // Using De Morgan: a|b = ~(~a & ~b)
    assign out_or_bitwise = ~(not_a & not_b);

    // Logical OR is (|a) OR (|b)
    assign out_or_logical = (|a) | (|b);

    // Concatenate inverted b (upper bits) and inverted a (lower bits)
    assign out_not = {not_b, not_a};

endmodule