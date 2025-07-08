module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // Calculate the feedback bit as XOR of tap bits and LSB q[0]
      // Since taps at positions 5 and 3 correspond to q[4] and q[2],
      // the feedback is q[0] ^ q[2]
      wire feedback = q[0] ^ q[2];

      // Shift right and update tapped bits with feedback XORed
      // Galois LFSR updates bits with tap:
      // For tapped bit positions, next bit = current bit XOR feedback
      // For other bits, next bit = previous bit
      q <= {feedback, q[4:1]};
    end
  end

endmodule