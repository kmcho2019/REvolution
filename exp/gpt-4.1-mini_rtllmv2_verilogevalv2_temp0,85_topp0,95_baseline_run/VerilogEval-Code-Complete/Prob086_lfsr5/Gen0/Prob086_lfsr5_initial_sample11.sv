module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // Initialize to 1 on reset
    end else begin
      // Save the LSB before shift
      wire feedback = q[0];
      // Shift right by one
      // For each bit:
      // q[4] <= q[4] ^ feedback  (tap at bit 5 -> index 4)
      // q[3] <= q[3] (no tap)
      // q[2] <= q[2] ^ feedback  (tap at bit 3 -> index 2)
      // q[1] <= q[1] (no tap)
      // q[0] <= q[1]
      q[0] <= q[1];
      q[1] <= q[2];
      q[2] <= q[3] ^ feedback;
      q[3] <= q[4];
      q[4] <= feedback ^ q[4];
    end
  end

endmodule