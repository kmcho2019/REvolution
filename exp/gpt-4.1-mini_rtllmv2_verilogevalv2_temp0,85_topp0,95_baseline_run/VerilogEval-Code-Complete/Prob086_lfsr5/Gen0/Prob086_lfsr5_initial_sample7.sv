module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);
  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // Feedback bit is q[0]
      // Taps at bit 5 (q[4]) and bit 3 (q[2])
      // For Galois LFSR:
      // q[4] <= q[3] ^ q[0]
      // q[3] <= q[2]
      // q[2] <= q[1] ^ q[0]
      // q[1] <= q[0]
      // q[0] <= q[4]
      // Actually, shift right by one with taps XORed in:
      q <= { (q[4] ^ q[0]), q[4], (q[2] ^ q[0]), q[1], q[0] };
    end
  end
endmodule