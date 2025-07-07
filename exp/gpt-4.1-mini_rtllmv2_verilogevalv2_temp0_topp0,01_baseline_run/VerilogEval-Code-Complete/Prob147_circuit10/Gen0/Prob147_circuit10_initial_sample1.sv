module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  wire next_q;

  assign next_q = (b & ~q) | (~a & b);
  assign state = q;

  always @(posedge clk) begin
    q <= next_q;
  end

endmodule