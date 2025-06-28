module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire m0, m1, m2, m3;
  
  assign m0 = (~c & d) | (c & ~d) | (c & d); // ab=00
  assign m1 = (~c & ~d);                       // ab=01
  assign m2 = (c & d) | (~c & d);              // ab=11
  assign m3 = (c & ~d) | (c & d) | (~c & d);   // ab=10
  
  assign mux_in = {m0, m1, m2, m3};
  
endmodule