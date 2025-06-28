module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire Y1, Y2, Y3, Y4;

  assign Y1 = (~c & d) | (c & ~d & ~a & b);
  assign Y2 = c & d & ~b | ~c & d & ~a | c & ~d & a | ~c & ~d & a;
  assign Y3 = c & ~d | c & d & ~a & ~b | ~c & d & ~a & b;
  assign Y4 = c | ~c & ~d | c & ~a | c & d & ~a & b;

  assign mux_in[0] = Y4;
  assign mux_in[1] = Y3;
  assign mux_in[2] = Y2;
  assign mux_in[3] = Y1;

endmodule