module TopModule(a, b, c, d, out_sop, out_pos);
  input a, b, c, d;
  output out_sop, out_pos;

  // Minimum Sum-of-Products form for out_sop
  assign out_sop = (a && ~b && c && ~d) || (~a && b && c && d) || 
                   (~a && b && c && ~d) || (~a && b && ~c && d) ||
                   (a && b && c && d) || (a && ~b && c && d) || 
                   (~a && ~b && c && d) || (a && b && ~c && d);

  // Minimum Product-of-Sums form for out_pos
  assign out_pos = (~((~a && ~b && ~c && ~d) || 
                     (a && ~b && ~c && ~d) || 
                     (~a && b && ~c && ~d) || 
                     (~a && ~b && c && ~d) || 
                     (~a && ~b && ~c && d) || 
                     (a && b && ~c && ~d) || 
                     (~a && b && c && ~d) || 
                     (~a && b && ~c && d) || 
                     (a && ~b && ~c && d)));
endmodule