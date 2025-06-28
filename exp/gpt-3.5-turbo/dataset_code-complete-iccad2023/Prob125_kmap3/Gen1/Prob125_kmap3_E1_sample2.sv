module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    // Simplified output expression based on the given relationship
    out = (b & c) | a;
  end

endmodule