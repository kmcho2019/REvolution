module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  // Tap positions: 32,22,2,1 correspond to indices 31,21,1,0 in zero-based indexing
  // Galois LFSR shifts right: q[i] next = q[i-1] if not tapped; if tapped, q[i] next = q[i-1] ^ q[0]
  // q[0] next = q[31] ^ q[21] ^ q[1] ^ q[0] (No, q[0] next = q[1], since shifting right)

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Compute feedback bit q[0]
      // For Galois LFSR, feedback is implicit by XORing q[0] into tapped bits during shift
      // New q[0] = q[1]
      // For tapped bits, q[i] <= q[i-1] ^ q[0]
      // For non-tapped bits, q[i] <= q[i-1]

      // Store current LSB before update
      wire feedback = q[0];
      reg [31:0] next_q;

      next_q[0] = q[1];
      // Bit 1 is tapped
      next_q[1] = q[2] ^ feedback;
      // Bit 21 is tapped
      next_q[21] = q[22] ^ feedback;
      // Bit 31 is tapped
      next_q[31] = q[0] ^ feedback; // Actually q[31] next = q[0] ^ feedback? 
      // Wait, q[31] next = q[30] ^ feedback (since q[31] next = q[30] ^ feedback)

      // Actually, correction:
      // next_q[i] = q[i-1] if not tapped
      // next_q[i] = q[i-1] ^ feedback if tapped
      // So for i=31 (bit 32), next_q[31] = q[30] ^ feedback

      // Now write the full next_q
      integer i;
      for (i = 1; i < 32; i = i + 1) begin
        if (i == 1 || i == 21 || i == 31) begin
          next_q[i] = q[i-1] ^ feedback;
        end else begin
          next_q[i] = q[i-1];
        end
      end
      q <= next_q;
    end
  end

endmodule