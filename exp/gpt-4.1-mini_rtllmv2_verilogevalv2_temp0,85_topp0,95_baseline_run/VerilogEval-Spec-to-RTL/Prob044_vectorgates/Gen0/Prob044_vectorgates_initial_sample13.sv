module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // logical OR of the two 3-bit inputs (treat as booleans, so OR of all bits)
    assign out_or_logical = (|a) || (|b);

    // inverse of b in upper half and inverse of a in lower half
    assign out_not = { ~b, ~a };

endmodule