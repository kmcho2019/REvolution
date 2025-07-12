module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b (3-bit output)
    assign out_or_bitwise = a | b;

    // Optimized logical OR: reduction OR of (a | b)
    assign out_or_logical = |(a | b);

    // NOT operations with proper bit ordering:
    // bits [5:3] = ~b, bits [2:0] = ~a
    assign out_not = {~b, ~a};

endmodule