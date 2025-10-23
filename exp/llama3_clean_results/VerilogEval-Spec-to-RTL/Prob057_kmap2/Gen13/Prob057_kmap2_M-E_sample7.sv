module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    out = 
    (~a & ~b & ~c & ~d) |  // Minterm 1
    (~a & ~b & ~c & d)  |  // Minterm 2
    (~a & ~b & c & d)   |  // Minterm 3
    (~a & b & ~c & ~d)  |  // Minterm 4
    (~a & b & ~c & d)   |  // Minterm 5
    (~a & b & c & d)    |  // Minterm 6
    (a & ~b & ~c & ~d)  |  // Minterm 7
    (a & ~b & ~c & d)   |  // Minterm 8
    (a & ~b & c & d)    |  // Minterm 9
    (a & b & c & d);     // Minterm 10

endmodule