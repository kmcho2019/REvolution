module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  wire feedback;

  // Calculate feedback by XORing the output bit q[0] with the tapped bits
  assign feedback = q[0] ^ q[21] ^ q[1] ^ q[0]; 
  // Note: q[0] XOR q[0] cancels out, so effectively taps are q[21] and q[1] XOR with q[0]
  // But we must include q[0] for tap bit 1, so the feedback is q[0] XOR q[21] XOR q[1] XOR q[0]
  // XORing q[0] twice cancels out, so feedback = q[21] ^ q[1]

  // Actually to be precise, the taps are at bit 32, 22, 2 and 1, which corresponds to bits 31, 21, 1, and 0.
  // The LSB q[0] is always XORed with tapped bits to produce next bit at each tap position.

  // Let's compute feedback as q[0], then each tapped bit is XORed with q[0] to get next bit for that position.
  // In Galois LFSR, bits without taps shift right unchanged.
  // The MSB bit (bit 31) input is feedback (which is q[0]), as it's a tap.
  // Bits with taps get next value = current bit XOR feedback.
  // Bits without taps get next value = current bit shifted right by 1.

  // So bits:
  // bit 31 (tap) next bit = q[31] ^ feedback
  // bit 21 (tap) next bit = q[21] ^ feedback
  // bit 1  (tap) next bit = q[1]  ^ feedback
  // bit 0  (tap) next bit = q[0]  (LSB output bit)
  // Other bits next bit = q[bit+1]

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      q[0]  <= q[1];
      q[1]  <= q[2] ^ feedback;   // tap at bit 2 (index 1)
      q[2]  <= q[3];
      q[3]  <= q[4];
      q[4]  <= q[5];
      q[5]  <= q[6];
      q[6]  <= q[7];
      q[7]  <= q[8];
      q[8]  <= q[9];
      q[9]  <= q[10];
      q[10] <= q[11];
      q[11] <= q[12];
      q[12] <= q[13];
      q[13] <= q[14];
      q[14] <= q[15];
      q[15] <= q[16];
      q[16] <= q[17];
      q[17] <= q[18];
      q[18] <= q[19];
      q[19] <= q[20];
      q[20] <= q[21];
      q[21] <= q[22] ^ feedback;  // tap at bit 22 (index 21)
      q[22] <= q[23];
      q[23] <= q[24];
      q[24] <= q[25];
      q[25] <= q[26];
      q[26] <= q[27];
      q[27] <= q[28];
      q[28] <= q[29];
      q[29] <= q[30];
      q[30] <= q[31];
      q[31] <= q[31] ^ feedback;  // tap at bit 32 (index 31)
    end
  end

endmodule