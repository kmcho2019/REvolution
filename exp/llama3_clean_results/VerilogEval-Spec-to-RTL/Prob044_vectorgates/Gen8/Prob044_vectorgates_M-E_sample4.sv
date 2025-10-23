module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Compute bitwise-OR directly
    assign out_or_bitwise = a | b;

    // Compute logical-OR directly
    assign out_or_logical = |a || |b;

    // Compute NOT of both vectors and assign as required
    assign out_not[5:3] = ~b; // Inverse of b in upper half
    assign out_not[2:0] = ~a; // Inverse of a in lower half
endmodule