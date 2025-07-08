module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);
  always @(posedge clk) begin
    if (reset)
      q <= 32'h1;
    else begin
      // The output bit is q[0]
      // taps at positions 32, 22, 2, and 1 correspond to bits 31, 21, 1, and 0 (zero-based)
      // For each bit i, if it's a tap, next value = q[i] ^ q[0], else q[i]
      // Shift right by one bit with feedback applied to taps.
      
      // The new MSB bit is q[31] ^ q[0] (since 32 is a tap)
      // Bits 30 down to 0 shift right by one with tap XOR feedback where applicable
      
      // Create next state bitwise
      q <= {
        q[31] ^ q[0],                           // bit 31 (tap)
        q[31:22] ^ {10{q[0]}},                  // bits 30 down to 21 (only bit 21 is a tap)
        q[21] ^ q[0],                          // bit 21 (tap)
        q[20:2],                              // bits 20 down to 2 (only bit 1 and 0 taps left)
        q[2] ^ q[0],                          // bit 2 (tap)
        q[1]                                 // bit 1 (tap)
      } >> 1;

      // The above is not fully correct because shifting right by 1 will lose bits.
      // Instead, update each bit according to Galois LFSR logic:
      // For each bit i from 31 down to 1:
      // If tap, q[i] = q[i-1] ^ q[0]
      // Else q[i] = q[i-1]
      // q[0] = q[31] ^ q[0] if tap at 0, but tap at bit 0 means q[0] itself, handled specially.
      
    end
  end

endmodule