module TopModule (
  input clk,
  input j,
  input k,
  output reg Q
);

  always @ (posedge clk) begin
    if (j & ~k)
      Q <= 1'b1; // Set Q to 1
    else if (~j & k)
      Q <= 1'b0; // Set Q to 0
    else if (j & k)
      Q <= ~Q; // Toggle Q
  end

endmodule