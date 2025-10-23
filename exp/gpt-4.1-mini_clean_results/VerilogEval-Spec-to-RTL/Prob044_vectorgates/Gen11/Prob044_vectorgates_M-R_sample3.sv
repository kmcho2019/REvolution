module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR directly assigned
    assign out_or_bitwise = a | b;

    // Logical OR by reduction OR of bitwise OR result
    assign out_or_logical = |out_or_bitwise;

    // Concatenate bitwise NOT of b in upper half, a in lower half
    assign out_not = {~b, ~a};

endmodule