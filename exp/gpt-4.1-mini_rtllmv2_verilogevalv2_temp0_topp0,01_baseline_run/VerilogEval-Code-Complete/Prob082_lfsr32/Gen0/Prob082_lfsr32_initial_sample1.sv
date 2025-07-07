module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  // Tap positions (1-based): 32, 22, 2, 1
  // In 0-based indexing: 31, 21, 1, 0
  // Galois LFSR: On each clock, if q[0] == 1, bits at tap positions are XORed with 1 before shifting.

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Save the LSB before shift
      wire feedback = q[0];
      // Shift right by 1
      // For tapped bits, XOR with feedback
      // For others, just shift right
      // Construct next state bit by bit:
      // q[31] <= q[30] ^ feedback (since tap at 32)
      // q[21] <= q[22] ^ feedback (tap at 22)
      // q[1]  <= q[2]  ^ feedback (tap at 2)
      // q[0]  <= q[1]  ^ feedback (tap at 1)
      // Other bits shift right normally

      q[31] <= q[30] ^ feedback;       // tap 32
      q[30:22] <= q[29:21];            // no tap
      q[21] <= q[20] ^ feedback;       // tap 22
      q[20:2] <= q[19:1];              // no tap
      q[1] <= q[0] ^ feedback;         // tap 2
      q[0] <= feedback;                // tap 1 is q[0], so next q[0] is feedback itself (q[0] before shift)
    end
  end

endmodule