module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs a and b
    assign out_or_bitwise = a | b;

    // Logical OR reduction directly on concatenated inputs to save one intermediate operation
    assign out_or_logical = |{a, b};

    // Bitwise NOT of b in upper half, bitwise NOT of a in lower half
    assign out_not = {~b, ~a};

endmodule