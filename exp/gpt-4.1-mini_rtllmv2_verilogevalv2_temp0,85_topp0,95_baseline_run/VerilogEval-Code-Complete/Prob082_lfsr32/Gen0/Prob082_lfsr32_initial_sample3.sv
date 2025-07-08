module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);
  // Tap positions (zero-based): 31, 21, 1, 0
  // On each clock:
  // q[i] = q[i+1] ^ (q[0] if tap at i+1 else 0), for i=0..30
  // q[31] = q[0] ^ q[31] (since tap at 32=31)
  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // feedback bit = q[0]
      wire fb = q[0];
      // next state calculation
      // For each bit:
      // q[31] <= q[0] ^ q[31]
      // q[21] <= q[22] ^ fb
      // q[1]  <= q[2]  ^ fb
      // q[0]  <= q[1]  ^ fb
      // All other bits shift right unchanged (q[i] <= q[i+1])
      // Note: For bits that are taps, XOR with fb
      q <= {
        q[0]   ^ q[31],           // bit 31 (tap)
        q[31:22] ^ {10{1'b0}},    // bits 30 downto 22 no tap except bit 21
        q[22]  ^ fb,              // bit 21 (tap)
        q[20:2],                  // bits 20 downto 2 no tap
        q[2]   ^ fb,              // bit 1 (tap)
        q[1]   ^ fb               // bit 0 (tap)
      };
    end
  end
endmodule