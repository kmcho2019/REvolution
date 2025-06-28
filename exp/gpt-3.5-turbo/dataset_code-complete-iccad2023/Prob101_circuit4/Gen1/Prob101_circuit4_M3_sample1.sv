module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  wire sum;

  assign sum = a + b + c + d;

  assign q = (sum >= 2) ? 1 : 0;

endmodule