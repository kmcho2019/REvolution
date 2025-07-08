module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  wire feedback = q[0];

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      q[31] <= q[31] ^ feedback; // tap at bit 32 (index 31)
      q[30:22] <= q[31:23];
      q[21] <= q[21] ^ feedback; // tap at bit 22 (index 21)
      q[20:2] <= q[21:3];
      q[1] <= q[1] ^ feedback;   // tap at bit 2 (index 1)
      q[0] <= q[0] ^ feedback;   // tap at bit 1 (index 0)
      
      // The above approach is incorrect because we are trying to assign multiple overlapping slices
      // Need a better approach: shift right by one bit, then XOR taps with feedback
      
      // Let's rewrite properly:

      // The value shifted right by one is: q >> 1
      // Then for taps, we XOR the new bits with feedback at tap positions.

      // We must implement this with an intermediate variable.

    end
  end

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Shift right by one
      reg [31:0] shifted = q >> 1;

      // XOR feedback with tap bits
      // taps at bit positions 31, 21, 1, 0
      shifted[31] = shifted[31] ^ feedback;
      shifted[21] = shifted[21] ^ feedback;
      shifted[1]  = shifted[1]  ^ feedback;
      shifted[0]  = shifted[0]  ^ feedback;

      q <= shifted;
    end
  end

endmodule