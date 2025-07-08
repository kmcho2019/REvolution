module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out,
  output out_n
);

  wire wire1;
  wire wire2;

  and and1(wire1, a, b);
  and and2(wire2, c, d);
  or  or1(out, wire1, wire2);
  not not1(out_n, out);

endmodule