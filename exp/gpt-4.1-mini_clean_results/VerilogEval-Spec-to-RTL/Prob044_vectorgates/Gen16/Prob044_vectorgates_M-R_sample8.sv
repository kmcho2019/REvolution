module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Direct bitwise NOT of inputs
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR reduction of a and b combined
    assign out_or_logical = |(a | b);

    // Concatenate inverted b in upper half and inverted a in lower half
    assign out_not = {not_b, not_a};

endmodule