module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);
  wire feedback = q[0];
  
  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // Reset to 1
    end else begin
      // Galois LFSR next state
      // For tapped bits (positions 5 and 3, i.e. q[4] and q[2]), XOR with feedback
      // Other bits shift right normally
      q[0] <= q[1];
      q[1] <= q[2];
      q[2] <= q[3] ^ feedback; // tap at bit 3
      q[3] <= q[4];
      q[4] <= feedback;        // tap at bit 5
    end
  end
endmodule