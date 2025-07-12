module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;

    // Logical OR as reduction OR of inputs a and b
    assign out_or_logical = |a | |b;

    // Bitwise NOT of inputs concatenated as {~b, ~a}
    assign out_not = {~b, ~a};

endmodule