module TopModule(clk, a, q);
  input clk, a;
  output [2:0] q;
  reg [2:0] q;

  always @(posedge clk) begin
    if (!a) begin
      if (q == 3'b110) // if q is 6, reset to 0 and then increment
        q <= 1;
      else if (q == 0) // if q is 0, increment to 1
        q <= 1;
      else
        q <= q + 1;
    end
    // if 'a' is 1, hold the current value of q
  end
endmodule