module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR of a and b using single reduction OR on bitwise OR result
    assign out_or_logical = |(a | b);

    // Inverted b goes to upper half, inverted a goes to lower half
    assign out_not = {~b, ~a};

endmodule