module TopModule (
  input clk,
  input in,
  output logic out
);

  logic d_ff;

  // D flip-flop triggered on positive edge of clock
  always_ff @(posedge clk) begin
    d_ff <= in ^ d_ff;
    out <= d_ff;
  end

endmodule