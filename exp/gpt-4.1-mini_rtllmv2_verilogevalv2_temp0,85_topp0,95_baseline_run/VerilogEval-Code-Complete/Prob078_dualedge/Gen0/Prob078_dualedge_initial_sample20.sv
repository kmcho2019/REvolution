module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_posedge;
  reg q_negedge;

  // Sample data on rising edge
  always @(posedge clk) begin
    q_posedge <= d;
  end

  // Sample data on falling edge
  always @(negedge clk) begin
    q_negedge <= d;
  end

  // Multiplex outputs based on clock level
  always @(*) begin
    if (clk)
      q = q_posedge;
    else
      q = q_negedge;
  end

endmodule