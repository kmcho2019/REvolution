module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR: Each bit is OR of corresponding bits in a and b
    assign out_or_bitwise = a | b;

    // Logical OR: True if any bit in either input is 1
    assign out_or_logical = (|a) | (|b);

    // Concatenated NOTs: ~b in bits[5:3], ~a in bits[2:0]
    assign out_not = {~b, ~a};

    /* Power Optimization Note:
     * In a system context, consider adding:
     * - Clock gating if unused in some cycles
     * - Input registers if high-frequency operation needed
     */
endmodule