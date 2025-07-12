module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression with fewer operations
assign out = (~a & ~b & c & d) |  // cd=11, ab=00
             (~c & d & b) |       // cd=01
             (c & ~d & a) |       // cd=10
             (a & b & ~c & ~d);   // cd=00, ab=11

endmodule