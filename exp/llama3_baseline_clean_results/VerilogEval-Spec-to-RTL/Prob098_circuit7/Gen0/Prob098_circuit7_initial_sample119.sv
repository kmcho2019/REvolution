module TopModule(clk, a, q);
  input clk, a;
  output q;
  reg q;
  
  always @(posedge clk) begin
    if (a) begin
      q <= ~q;
    end
  end
  
  // Initialization
  initial begin
    q <= 1'b1;
  end
  
endmodule