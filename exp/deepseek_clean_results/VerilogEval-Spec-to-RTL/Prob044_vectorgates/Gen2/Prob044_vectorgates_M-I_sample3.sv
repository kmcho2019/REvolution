module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b (already optimal)
    assign out_or_bitwise = a | b;

    // Optimized logical OR using separate reduction operations
    assign out_or_logical = (|a) || (|b);

    // NOT of b in upper 3 bits, NOT of a in lower 3 bits (optimal)
    assign out_not = {~b, ~a};

endmodule