module TopModule(clk, a, q);
  input clk, a;
  output q;
  reg q;

  initial q = 1'b0;

  always @(posedge clk)
    begin
      if (a == 1'b1)
        q <= ~q;
      else if ($time > 10)  // To ensure q is set to 1 after the first clock edge when a is 0
        q <= 1'b1;
    end
endmodule