module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise OR of inputs directly on output
    assign out_or_bitwise = a | b;

    // Logical OR is reduction OR of concatenated inputs (equivalent to reduction OR of bitwise OR)
    assign out_or_logical = |{a, b};

    // Assign inverted b in upper half and inverted a in lower half by concatenation
    assign out_not = {~b, ~a};

endmodule