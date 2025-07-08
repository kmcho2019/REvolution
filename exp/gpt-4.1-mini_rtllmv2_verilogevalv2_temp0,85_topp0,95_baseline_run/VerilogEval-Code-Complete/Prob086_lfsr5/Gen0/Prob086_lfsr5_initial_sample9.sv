module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // reset to 1 to avoid all-zero state
    end else begin
      // Calculate feedback from taps and LSB
      // taps at bit positions 5 and 3 correspond to q[4] and q[2]
      wire feedback = q[0] ^ q[4] ^ q[2];
      
      // Shift right, q[4] gets feedback, other bits get previous bit
      q <= {feedback, q[4:1]};
    end
  end

endmodule