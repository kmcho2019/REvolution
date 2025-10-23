module TopModule(a, b, c, d, out_sop, out_pos);
  input a, b, c, d;
  output out_sop, out_pos;

  // Minimum Sum-of-Products (SOP) form for out_sop
  // The output is 1 for the input conditions 2, 7, and 15
  assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

  // Minimum Product-of-Sums (POS) form for out_pos
  // The output is 1 for the input conditions not in 0, 1, 4, 5, 6, 9, 10, 13, 14
  assign out_pos = ~( (a & ~b & ~c & ~d) | 
                      (a & ~b & ~c & d) | 
                      (~a & b & ~c & ~d) | 
                      (~a & b & c & ~d) | 
                      (~a & ~b & c & ~d) | 
                      (a & b & ~c & d) | 
                      (~a & ~b & ~c & d) | 
                      (~a & b & ~c & d) | 
                      (~a & ~b & c & d) );
endmodule