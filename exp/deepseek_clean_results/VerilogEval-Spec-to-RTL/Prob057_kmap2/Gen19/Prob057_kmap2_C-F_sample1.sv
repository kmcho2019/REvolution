module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best of both examples with additional coverage
assign out = (!a & !b & c & d) |  // cd=11,ab=00
              (!c & d & b) |       // cd=01,ab=01 and cd=01,ab=11
              (c & !d & a) |       // cd=10,ab=11 and cd=10,ab=10
              (a & b & !c & !d) |  // cd=00,ab=11
              (!a & b & !c & d);   // additional coverage for cd=01,ab=01

endmodule