module TopModule (
  input clk,
  input d,
  input ar,
  output logic q
);

  always_ff @(posedge clk or posedge ar)
    if (ar)
      q <= 1'b0;   // Asynchronous reset
    else
      q <= d;      // D flip flop behavior

endmodule