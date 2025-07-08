module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  // Tap positions (1-based): 32, 22, 2, 1
  // Convert to zero-based: 31, 21, 1, 0

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // feedback bit is q[0]
      wire feedback = q[0];
      // next value calculation
      // Shift right: q[i] = q[i+1] XOR (feedback & tap)
      // For bit 31 (MSB): no q[32], so next bit is feedback XOR q[31] if tapped
      // Actually, MSB next bit is feedback XOR q[31] only if tapped, else q[31+1] (which doesn't exist)
      // But since shift right, q[31] next bit = q[32] XOR (feedback & tap)
      // q[32] doesn't exist, so MSB is feedback if tapped, else 0

      // We'll create a temporary next_q
      reg [31:0] next_q;
      integer i;

      next_q[31] = q[31] ^ (feedback & 1'b1); // bit 31 tapped
      next_q[21] = q[22] ^ (feedback & 1'b1); // bit 21 tapped
      next_q[1]  = q[2]  ^ (feedback & 1'b1); // bit 1 tapped
      next_q[0]  = q[1];                       // bit 0 not tapped, shifts from bit 1

      // For bits that are not tapped and not MSB or 0 or tap bits
      // Fill other bits:
      // For each bit i (0..30) except taps, next_q[i] = q[i+1]
      // Already done 0,1,21,31 explicitly

      for (i = 0; i < 32; i = i + 1) begin
        if (i != 0 && i != 1 && i != 21 && i != 31) begin
          next_q[i] = q[i+1];
        end
      end

      q <= next_q;
    end
  end

endmodule