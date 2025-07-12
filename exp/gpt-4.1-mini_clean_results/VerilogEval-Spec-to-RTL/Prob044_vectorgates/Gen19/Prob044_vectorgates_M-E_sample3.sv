module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR reduction of both vectors combined
    assign out_or_logical = |{a, b};

    // Concatenate inverted b (upper) and inverted a (lower)
    assign out_not = {~b, ~a};

endmodule