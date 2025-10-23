module TopModule(clk, a, q);
  input clk, a;
  output q;
  reg q;
  reg first_zero;

  initial begin
    q = 1'b0;
    first_zero = 1'b0;
  end

  always @(posedge clk)
    begin
      if (!first_zero && !a)
        begin
          q <= 1'b1;
          first_zero <= 1'b1;
        end
      else if (a)
        q <= ~q;
    end
endmodule