module TopModule(input clk, input a, output reg q);

  initial q = 0; // initialize q to 0

  always @(posedge clk) begin
    if (a == 0)
      q <= 1;
    else // a == 1
      q <= ~q;
  end

endmodule