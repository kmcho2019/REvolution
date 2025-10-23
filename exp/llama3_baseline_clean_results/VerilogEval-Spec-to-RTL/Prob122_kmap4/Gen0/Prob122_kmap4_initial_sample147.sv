module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Directly from the Karnaugh map, we can see that 'out' is 1 under the following conditions:
// (a == 0 && b == 0 && c == 0 && d == 1) ||
// (a == 0 && b == 0 && c == 1 && d == 0) ||
// (a == 0 && b == 1 && c == 0 && d == 0) ||
// (a == 0 && b == 1 && c == 1 && d == 1) ||
// (a == 1 && b == 0 && c == 0 && d == 0) ||
// (a == 1 && b == 0 && c == 1 && d == 0) ||
// (a == 1 && b == 1 && c == 0 && d == 1) ||
// (a == 1 && b == 1 && c == 1 && d == 0)

assign out = ((~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & b & ~c & ~d) | (~a & b & c & d) | 
              (a & ~b & ~c & ~d) | (a & ~b & c & ~d) | (a & b & ~c & d) | (a & b & c & ~d));

endmodule