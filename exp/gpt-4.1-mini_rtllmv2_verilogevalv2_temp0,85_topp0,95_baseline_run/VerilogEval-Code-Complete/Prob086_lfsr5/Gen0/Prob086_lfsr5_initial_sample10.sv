module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // Calculate feedback as q[0]
      // For Galois LFSR, bits with taps get XORed with q[0]
      // Taps at bit 5 and 3 correspond to q[4] and q[2] in zero-based index

      // Save q[0] as feedback
      wire feedback = q[0];

      // Shift right, and XOR tapped bits with feedback
      q[0] <= q[1];
      q[1] <= q[2];
      q[2] <= q[3] ^ feedback; // tap at bit 3 (q[2])
      q[3] <= q[4];
      q[4] <= feedback ^ q[4]; // tap at bit 5 (q[4])
    end
  end

endmodule