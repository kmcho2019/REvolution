module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR: OR all bits of a, OR all bits of b, then OR those results
    assign out_or_logical = (|a) | (|b);

    // NOT of b in upper 3 bits, NOT of a in lower 3 bits
    assign out_not = {~b, ~a};

endmodule