module TopModule(
    input  a,
    input  b,
    input  c,
    output wire out
);

// Karnaugh map representation:
//          a
//     bc   0   1
//     00 | 0 | 1 |
//     01 | 1 | 1 |
//     11 | 1 | 1 |
//     10 | 1 | 1 |
// Output is 1 for all inputs except a=0, b=0, c=0.
// Minimal logic expression: out = a OR b OR c.
assign out = a | b | c;

endmodule