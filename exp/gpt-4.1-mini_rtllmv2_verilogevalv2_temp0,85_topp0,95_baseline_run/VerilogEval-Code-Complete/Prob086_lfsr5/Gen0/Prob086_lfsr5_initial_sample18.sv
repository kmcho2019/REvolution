module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // synchronous reset to 1
    end else begin
      // feedback is the output bit q[0]
      wire feedback = q[0];
      q[0] <= q[1];
      // q[1] has no tap, so just shift q[2]
      q[1] <= q[2];
      // q[2] has tap, so XOR with feedback
      q[2] <= q[3] ^ feedback;
      // q[3] has no tap, shift q[4]
      q[3] <= q[4];
      // q[4] has tap, XOR with feedback
      q[4] <= feedback ^ q[4];
    end
  end

endmodule