module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of input vectors using vector operator
    assign out_or_bitwise = a | b;

    // Logical OR using a single reduction OR over concatenated inputs
    assign out_or_logical = |{a, b};

    // Concatenate inverted b in upper half and inverted a in lower half
    assign out_not = {~b, ~a};

endmodule