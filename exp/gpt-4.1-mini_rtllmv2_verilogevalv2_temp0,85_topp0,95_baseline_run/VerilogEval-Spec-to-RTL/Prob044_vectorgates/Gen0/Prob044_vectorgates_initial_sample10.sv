module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    assign out_or_bitwise = a | b;              // bitwise OR of a and b
    assign out_or_logical = |a || |b;           // logical OR of the two vectors
    assign out_not[5:3]   = ~b;                 // NOT of b in upper half
    assign out_not[2:0]   = ~a;                 // NOT of a in lower half
endmodule