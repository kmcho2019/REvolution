module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // q[0] is the output bit used for feedback
      wire feedback = q[0];

      // Calculate next state
      // For Galois LFSR:
      // q[4] <= q[4] XOR feedback (tap at bit 5)
      // q[3] <= q[4]
      // q[2] <= q[2] XOR feedback (tap at bit 3)
      // q[1] <= q[2]
      // q[0] <= q[1]

      // Implement shifting with taps
      q[4] <= q[4] ^ feedback;
      q[3] <= q[4];
      q[2] <= q[2] ^ feedback;
      q[1] <= q[2];
      q[0] <= q[1];
    end
  end

endmodule