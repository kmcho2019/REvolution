module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Direct bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR reduction of the OR result
    assign out_or_logical = |(a | b);

    // Invert b in upper half [5:3], invert a in lower half [2:0]
    assign out_not = {~b, ~a};

endmodule