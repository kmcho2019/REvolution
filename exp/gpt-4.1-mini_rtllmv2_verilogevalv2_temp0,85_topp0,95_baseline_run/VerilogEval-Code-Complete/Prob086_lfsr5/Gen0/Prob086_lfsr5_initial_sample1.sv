module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  wire feedback = q[0];
  wire tap2 = q[2];
  wire tap4 = q[4];

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // Reset to 1
    end else begin
      // Compute the new bits for the register following Galois LFSR logic
      // Bit 4 (MSB) = q[0] XOR q[4]
      // Bit 3 = q[3] XOR q[0] if tap3 (position 3) else q[3], here tap3 is bit 2 (index 2)
      // But the standard Galois LFSR shifts right with taps XORed with q[0] at their positions.
      // For bits with taps, next bit = current bit XOR feedback (q[0])
      // For bits without taps, next bit = current bit
      // Finally, q[0] shifts in the result from the next higher bit

      q[0] <= q[1];
      q[1] <= q[2];
      q[2] <= q[3] ^ feedback; // tap at bit 3 (index 2)
      q[3] <= q[4];
      q[4] <= feedback ^ q[4]; // tap at bit 5 (index 4)
    end
  end

endmodule