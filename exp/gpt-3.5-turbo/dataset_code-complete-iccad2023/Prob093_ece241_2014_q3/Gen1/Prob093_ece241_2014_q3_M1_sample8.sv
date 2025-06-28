module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire m0, m1, m2, m3;
  
  assign m0 = ~c & ~d;
  assign m1 = c & ~d;
  assign m2 = c & d;
  assign m3 = (c | d) & (~a | b);

  assign mux_in = {m0, m1, m3, m2};
  
endmodule