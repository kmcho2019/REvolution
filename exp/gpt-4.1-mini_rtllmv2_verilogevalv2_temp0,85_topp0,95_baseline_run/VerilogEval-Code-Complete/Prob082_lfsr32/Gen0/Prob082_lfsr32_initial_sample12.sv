module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // taps at bits 32,22,2,1 correspond to zero-based indexes 31,21,1,0
      wire feedback = q[0];
      q[0]  <= q[1];
      q[1]  <= q[2]  ^ feedback; // tap at bit 2
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
      q[20] <= q[21] ^ feedback; // tap at bit 22
      q[21] <= q[22];
      q[22] <= q[23];
      q[23] <= q[24];
      q[24] <= q[25];
      q[25] <= q[26];
      q[26] <= q[27];
      q[27] <= q[28];
      q[28] <= q[29];
      q[29] <= q[30];
      q[30] <= q[31];
      q[31] <= feedback ^ q[31] ^ feedback; // tap at bit 32, XOR with feedback bit (simplifies to q[31]^feedback)
      // Simplify: q[31] <= q[31]^feedback
      q[31] <= q[31] ^ feedback;

      // Also tap at bit 1 (q[0]) XOR with feedback is q[0]^feedback, but feedback = q[0], so XOR cancels out
      // This means q[0] tapped is handled by the shift. So no extra XOR needed.

      // But position 1 (bit 1) tap means q[0]^feedback for next bit 1
      // We already have q[1] <= q[2]^feedback, so bit 1 tap handled.

    end
  end
endmodule