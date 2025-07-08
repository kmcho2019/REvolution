module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);
  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // reset to 1
    end else begin
      // Calculate feedback bit: XOR of q[0] and q[2] (tap positions 5 and 3)
      // Note: bit positions are 1-based in problem; q[4] is bit 5, q[2] is bit 3
      wire feedback = q[0] ^ q[2];
      q <= {feedback, q[4:1]};
    end
  end
endmodule