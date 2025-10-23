module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR of inputs: single reduction OR on concatenated inputs to avoid redundant OR
    assign out_or_logical = |{a, b};

    // Concatenate inverted b (upper half) and inverted a (lower half) directly without intermediate wires
    assign out_not = {~b, ~a};

endmodule