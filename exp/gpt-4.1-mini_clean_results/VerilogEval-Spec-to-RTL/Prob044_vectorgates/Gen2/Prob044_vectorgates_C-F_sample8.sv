module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    assign out_or_bitwise = a | b;
    assign out_or_logical = |{a, b};          // Single reduction OR on concatenated inputs
    assign out_not[5:3] = ~b;                  // Upper half: inverse of b
    assign out_not[2:0] = ~a;                  // Lower half: inverse of a

endmodule