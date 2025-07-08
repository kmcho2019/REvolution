module TopModule (
  input clk,
  input d,
  output reg q
);

  reg d_posedge, d_negedge;

  // Capture d on rising edge
  always @(posedge clk) begin
    d_posedge <= d;
  end

  // Capture d on falling edge
  always @(negedge clk) begin
    d_negedge <= d;
  end

  // Multiplex outputs depending on clock level
  always @(*) begin
    if (clk)
      q = d_posedge;
    else
      q = d_negedge;
  end

endmodule