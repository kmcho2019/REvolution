module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out,
  output out_n
);

  wire w1, w2;
  wire out_wire, out_n_wire;

  and gate1 (w1, a, b);
  and gate2 (w2, c, d);
  or gate3 (out_wire, w1, w2);
  not gate4 (out_n_wire, out_wire);

  assign out = out_wire;
  assign out_n = out_n_wire;

endmodule

module and(
  output reg f,
  input a,
  input b
);
  always @* begin
    f = a & b;
  end
endmodule

module or(
  output reg f,
  input a,
  input b
);
  always @* begin
    f = a | b;
  end
endmodule

module not(
  output reg f,
  input a
);
  always @* begin
    f = ~a;
  end
endmodule