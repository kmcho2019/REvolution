module TopModule(a, b, c, d, e, q);
  input [3:0] a, b, c, d, e;
  output [3:0] q;
  
  always @(*)
    case (c)
      4'b0000: q = b;
      4'b0001: q = e;
      4'b0010: q = a;
      4'b0011: q = d;
      default: q = d; // since for c values above 3, q is 'f' which in this case is d
    endcase
endmodule