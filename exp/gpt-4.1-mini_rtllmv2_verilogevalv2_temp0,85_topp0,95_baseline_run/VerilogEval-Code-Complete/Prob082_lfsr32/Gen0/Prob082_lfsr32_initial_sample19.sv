module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);
  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Extract the LSB, which is q[0]
      wire feedback = q[0];

      // Shift right by 1
      // Each bit with a tap is XORed with feedback
      // Taps at bits: 32,22,2,1
      // Since bits are 0-indexed in q[31:0], taps correspond to:
      // bit 31 (32), bit 21 (22), bit 1 (2), bit 0 (1)
      // Shift right moves q[i] to q[i-1]

      q[31] <= q[30] ^ (feedback);             // bit 31 tap (32)
      q[30] <= q[29];                          // no tap
      q[29] <= q[28];                          // no tap
      q[28] <= q[27];                          // no tap
      q[27] <= q[26];                          // no tap
      q[26] <= q[25];                          // no tap
      q[25] <= q[24];                          // no tap
      q[24] <= q[23];                          // no tap
      q[23] <= q[22];                          // no tap
      q[22] <= q[21] ^ (feedback);             // bit 21 tap (22)
      q[21] <= q[20];                          // no tap
      q[20] <= q[19];                          // no tap
      q[19] <= q[18];                          // no tap
      q[18] <= q[17];                          // no tap
      q[17] <= q[16];                          // no tap
      q[16] <= q[15];                          // no tap
      q[15] <= q[14];                          // no tap
      q[14] <= q[13];                          // no tap
      q[13] <= q[12];                          // no tap
      q[12] <= q[11];                          // no tap
      q[11] <= q[10];                          // no tap
      q[10] <= q[9];                           // no tap
      q[9]  <= q[8];                           // no tap
      q[8]  <= q[7];                           // no tap
      q[7]  <= q[6];                           // no tap
      q[6]  <= q[5];                           // no tap
      q[5]  <= q[4];                           // no tap
      q[4]  <= q[3];                           // no tap
      q[3]  <= q[2];                           // no tap
      q[2]  <= q[1] ^ (feedback);              // bit 1 tap (2)
      q[1]  <= q[0] ^ (feedback);              // bit 0 tap (1)
      q[0]  <= 1'b0;                          // shifted in zero (no input)
    end
  end
endmodule