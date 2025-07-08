module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // bitwise OR of a and b
    assign out_or_bitwise = a | b;
    // logical OR of a and b: if any bit in a or b is set, output is 1
    assign out_or_logical = |a | |b;
    // out_not upper half [5:3] is ~b, lower half [2:0] is ~a
    assign out_not = {~b, ~a};

endmodule