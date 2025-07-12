module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR of inputs: reduce each vector, then OR results
    assign out_or_logical = (|a) | (|b);

    // Concatenate inverted b (upper 3 bits) and inverted a (lower 3 bits)
    assign out_not = {~b, ~a};

endmodule