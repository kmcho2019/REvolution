module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR: each bit is OR of corresponding a and b bits
    assign out_or_bitwise = a | b;

    // Logical OR: 1 if any bit in a OR b is 1 (optimized version)
    assign out_or_logical = |(a | b);

    // NOT operations:
    // bits[5:3] = ~b[2:0]
    // bits[2:0] = ~a[2:0]
    assign out_not = {~b, ~a};

endmodule