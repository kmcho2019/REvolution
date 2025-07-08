module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  // Tap positions: bits 5 and 3 correspond to q[4] and q[2]
  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // reset to 1
    end else begin
      // Calculate feedback taps
      // According to Galois LFSR:
      // q[4] <= q[0] ^ q[4] (tap)
      // q[3] <= q[4]
      // q[2] <= q[0] ^ q[2] (tap)
      // q[1] <= q[2]
      // q[0] <= q[1]

      // Save old q for calculation
      wire lsb = q[0];
      q[4] <= lsb ^ q[4];
      q[3] <= q[4];
      q[2] <= lsb ^ q[2];
      q[1] <= q[2];
      q[0] <= q[1];
    end
  end

endmodule