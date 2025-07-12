module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Compute the bitwise-OR of 'a' and 'b'
    assign out_or_bitwise = a | b;

    // Compute the logical-OR of 'a' and 'b'
    // We use the '|' operator with a reduction operator to perform a logical OR
    assign out_or_logical = |a || |b;

    // Compute the inverse (NOT) of both 'a' and 'b'
    // Place the inverse of 'b' in the upper half of 'out_not' and the inverse of 'a' in the lower half
    assign out_not = {~b, ~a};

endmodule