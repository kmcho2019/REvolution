module TopModule(input clk, input ar, input d, output reg q);
  wire ce = (d != q) || ar;
  always @(posedge clk or posedge ar)
    if (ar) q <= 0;
    else if (ce) q <= d;
endmodule