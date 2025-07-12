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

    // Logical OR of inputs, optimized as a single reduction OR of combined vectors
    assign out_or_logical = |(a | b);

    // Concatenate inverted b (upper half) and inverted a (lower half)
    assign out_not = {not_b, not_a};

endmodule