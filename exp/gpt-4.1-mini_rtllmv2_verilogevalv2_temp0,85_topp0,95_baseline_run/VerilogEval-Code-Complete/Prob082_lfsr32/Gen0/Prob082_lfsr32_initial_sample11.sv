module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Extract feedback bit
      wire fb = q[0];

      // Compute next state bits
      // For i in [31:0]:
      // if (tap at i+1) next_bit = q[i+1] ^ fb else q[i+1]
      // Since q[32] doesn't exist, for i=31 (bit 32), next q[31] = fb
      // taps at bit positions 32,22,2,1 correspond to bit indices 31,21,1,0
      q <= {
        fb ^ q[21],    // bit 31 (tap at 22)
        q[31:22] ^ {10{fb}}, // bits 30 down to 22, taps only at 22, so only bit 21 tap, handle separately above
        fb ^ q[1],     // bit 21 (this is tap at 22, handled above)
        q[20:2],       // bits 20 down to 2 no taps here except bit 2 (index 1) handled below
        fb ^ q[1],     // bit 1 (tap at 2)
        q[1],          // bit 0 (tap at 1)
        fb            // bit 0 is replaced by fb
      };
    end
  end
endmodule