module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @(*) begin
    if ((c ^ d) == 1'b0) // c XOR d == 0
      out = a ^ b;       // output = a XOR b
    else
      out = ~(a ^ b);    // output = a XNOR b
  end

endmodule