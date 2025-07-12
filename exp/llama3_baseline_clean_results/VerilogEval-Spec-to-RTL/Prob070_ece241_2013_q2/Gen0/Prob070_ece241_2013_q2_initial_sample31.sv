module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products form for out_sop
assign out_sop = (b & ~a & ~c & ~d) | // 2
                 (~a & b & c & d)  | // 7
                 (a & b & c & d);    // 15

// Minimum Product-of-Sums form for out_pos
// Considering the conditions where out_pos should be 0 and inverting them
assign out_pos = ~((~a & ~b & ~c & ~d) | // 0
                  (a & ~b & ~c & ~d)  | // 1
                  (~a & ~b & c & ~d)  | // 4
                  (~a & b & c & ~d)   | // 5
                  (~a & ~b & c & d)   | // 6
                  (~a & b & ~c & d)   | // 9
                  (a & ~b & ~c & d)   | // 10
                  (~a & b & ~c & ~d)  | // 13
                  (a & ~b & c & ~d));  // 14

endmodule