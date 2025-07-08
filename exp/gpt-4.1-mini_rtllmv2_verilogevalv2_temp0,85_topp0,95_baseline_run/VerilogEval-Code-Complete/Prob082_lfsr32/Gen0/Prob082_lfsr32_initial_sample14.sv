module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  // Tap positions zero-indexed: 31, 21, 1, 0
  // On each clock, shift right. For tap bits, next bit = q[i-1] ^ q[0].
  // For non-tap bits (except bit 0), next bit = q[i-1].
  // q[0] is always replaced by q[0] (the LSB shifts in from somewhere - for Galois LFSR, the input bit is q[0] XOR taps, but since taps are in internal bits, the input bit is q[0].
  // Actually, in Galois LFSR, bit 0 gets q[0] XOR'ed with the taps at the next bit level. But since q[0] is output bit, it is used to conditionally flip bits at tap positions while q shifts right.
  // Implementation: On each clock cycle, save q[0] as feedback bit, then for each bit i:
  // if i is tap position, q[i] <= q[i-1] ^ feedback
  // else q[i] <= q[i-1]
  // For bit 0, q[0] <= feedback (the last bit shifted in).
  
  integer i;
  wire feedback = q[0];
  wire [31:0] taps_mask = 32'b10000000000000000000100000000011; // bits 31,21,1,0

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Shift right with feedback XOR on taps
      q[0] <= feedback;
      for (i = 1; i < 32; i = i + 1) begin
        if (taps_mask[i])
          q[i] <= q[i-1] ^ feedback;
        else
          q[i] <= q[i-1];
      end
    end
  end

endmodule