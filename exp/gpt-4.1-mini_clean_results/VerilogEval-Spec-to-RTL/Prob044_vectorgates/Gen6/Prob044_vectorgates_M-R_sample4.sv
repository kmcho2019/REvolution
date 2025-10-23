module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR of any bit set in a or b
    assign out_or_logical = |(a | b);

    // Concatenate bitwise NOT of b (upper bits) and a (lower bits)
    assign out_not = {~b, ~a};

endmodule