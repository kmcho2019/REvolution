module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR of all bits of a and b: true if any bit in a or b is 1
    assign out_or_logical = |(a | b);

    // Upper half: bitwise NOT of b; lower half: bitwise NOT of a
    assign out_not = {~b, ~a};

endmodule