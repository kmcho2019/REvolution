module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;

    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR as single reduction over concatenated inputs for minimal logic and power
    assign out_or_logical = |{a, b};

    // Concatenate inverted b (upper half) and inverted a (lower half)
    assign out_not = {not_b, not_a};

endmodule