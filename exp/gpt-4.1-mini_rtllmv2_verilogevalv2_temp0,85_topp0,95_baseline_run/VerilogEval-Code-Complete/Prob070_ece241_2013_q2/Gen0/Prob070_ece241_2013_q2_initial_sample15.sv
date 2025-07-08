module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimal SOP: m2 + m7 + m15
  assign out_sop = ( ~a & ~b &  c & ~d )  // 2 = 0010
                 | ( ~a &  b &  c &  d )  // 7 = 0111
                 | (  a &  b &  c &  d ); // 15= 1111

  // Minimal POS: (a + b + c + ~d)(~a + b + ~c + d)(~a + ~b + c + d)
  assign out_pos = (a | b | c | ~d) 
                 & (~a | b | ~c | d) 
                 & (~a | ~b | c | d);

endmodule