module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);
  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // Calculate feedback: q[0] XOR q[4] XOR q[2]
      wire feedback = q[0] ^ q[4] ^ q[2];

      // Shift right with taps XORed with feedback
      q[4] <= q[3];
      q[3] <= q[2];
      q[2] <= q[1] ^ feedback; // tap at bit 3 (index 2)
      q[1] <= q[0];
      q[0] <= feedback;        // LSB gets feedback
    end
  end
endmodule