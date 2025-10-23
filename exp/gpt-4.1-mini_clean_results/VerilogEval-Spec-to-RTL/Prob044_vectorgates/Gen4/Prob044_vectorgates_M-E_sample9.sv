module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Compute inverted inputs first
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;

    // Compute bitwise OR via De Morgan's Law: a | b = ~(~a & ~b)
    assign out_or_bitwise = ~(not_a & not_b);

    // Logical OR is the reduction OR of the bitwise OR result
    assign out_or_logical = |out_or_bitwise;

    // Concatenate inverted b and inverted a as required for out_not
    assign out_not = {not_b, not_a};

endmodule