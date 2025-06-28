module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  assign out = 
    (c & !d) |  // 01
    (!c & !d) | // 00
    (a & c) |   // 10
    (c | d);    // 11

endmodule