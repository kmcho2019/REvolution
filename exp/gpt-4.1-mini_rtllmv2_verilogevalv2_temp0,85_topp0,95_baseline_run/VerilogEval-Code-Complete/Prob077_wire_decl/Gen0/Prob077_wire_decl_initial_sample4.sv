module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out,
  output out_n
);

  wire and_ab;
  wire and_cd;

  and and_gate1 (and_ab, a, b);
  and and_gate2 (and_cd, c, d);
  or  or_gate    (out, and_ab, and_cd);
  not not_gate   (out_n, out);

endmodule