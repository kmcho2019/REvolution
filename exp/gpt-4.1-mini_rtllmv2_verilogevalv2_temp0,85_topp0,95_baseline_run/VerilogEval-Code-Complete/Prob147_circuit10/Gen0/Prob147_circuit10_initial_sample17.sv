module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  wire d;
  wire state_internal;
  assign state_internal = q;
  assign state = state_internal;

  assign d = (b & ~a) | (state_internal & ~(a & b));

  always @(posedge clk) begin
    q <= d;
  end

endmodule