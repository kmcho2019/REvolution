module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  wire q_next;
  assign state = q;
  assign q_next = (b & ~a) | (q & ~(a & b));

  always @(posedge clk) begin
    q <= q_next;
  end

endmodule