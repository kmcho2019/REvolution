module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);
  // Tap positions (1-based): 32, 22, 2, 1
  // Corresponding 0-based indices: 31, 21, 1, 0

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Extract the LSB bit (q[0]) which is the output bit
      wire feedback = q[0];
      reg [31:0] next_q;

      // Shift right by 1 with Galois taps
      // For tapped bits, XOR feedback with the bit shifted from the left
      // For non-tapped bits, just shift right by 1
      next_q[31] = q[0] ^ q[31]; // tap at bit 32 (q[31])
      next_q[30:22] = q[31:23];
      next_q[21] = q[0] ^ q[21]; // tap at bit 22 (q[21])
      next_q[20:2] = q[21:3];
      next_q[1] = q[0] ^ q[1]; // tap at bit 2 (q[1])
      next_q[0] = q[0] ^ q[0]; // tap at bit 1 (q[0]) - XOR with itself always zero

      // The last assignment zeroes q[0]; but in Galois LFSR, LSB is just q[1]
      // Actually, bit 0 is the feedback bit shifted in, so it comes from q[1]
      // So q[0] = q[1] in shift right, with tap at bit 1 means XOR with feedback
      // The tap at bit 1 means next_q[0] = q[0] ^ q[0] is zero, incorrect

      // Reconsidering:
      // Galois LFSR with taps at 32, 22, 2, 1 means these bits XOR feedback
      // The next state of bit i = q[i+1] XOR (feedback if i+1 is tapped, else 0)
      // The LSB (bit 0) gets q[1] XOR (feedback if bit 1 tapped)
      // Since bit 1 is tapped, next_q[0] = q[1] ^ feedback

      next_q[0] = q[1] ^ feedback;

      q <= next_q;
    end
  end
endmodule