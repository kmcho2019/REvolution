module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // Calculate feedback bit (XOR of q[0], q[4], and q[2])
      wire feedback = q[0] ^ q[4] ^ q[2];
      // Shift right with taps at bit 5 (q[4]) and bit 3 (q[2])
      q[0] <= q[1];
      q[1] <= q[2];
      q[2] <= q[3] ^ feedback; // tap at bit 3
      q[3] <= q[4];
      q[4] <= feedback;        // tap at bit 5
    end
  end

endmodule