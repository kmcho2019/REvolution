module TopModule(clk, d, r, q);
  input clk, d, r;
  output reg q;
  
  always @(posedge clk) begin
    if (r)
      q <= 0;
    else if (d != q)
      q <= d;
  end
endmodule