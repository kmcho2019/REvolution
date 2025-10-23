module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b (unchanged, already optimal)
    assign out_or_bitwise = a | b;

    // Optimized logical OR - single reduction OR of concatenated inputs
    assign out_or_logical = |{a, b};

    // NOT operations (unchanged, optimal organization)
    assign out_not = {~b, ~a};

endmodule