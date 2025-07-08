module TopModule (
  input clk,
  input d,
  output reg q
);

  // On rising edge, sample d
  always @(posedge clk) begin
    q <= d;
  end

  // On falling edge, sample d
  always @(negedge clk) begin
    q <= d;
  end

endmodule