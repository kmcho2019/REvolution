module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // logical OR of a and b (if any bit is 1)
    assign out_or_logical = |a | |b;

    // inverse of b placed in upper half [5:3]
    assign out_not[5:3] = ~b;

    // inverse of a placed in lower half [2:0]
    assign out_not[2:0] = ~a;

endmodule