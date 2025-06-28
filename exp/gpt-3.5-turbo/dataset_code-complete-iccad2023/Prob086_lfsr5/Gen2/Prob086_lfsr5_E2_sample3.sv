module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end
  else begin
    // Galois LFSR with taps at bit positions 5 and 3
    q <= {q[4] ^ (q[3] ^ q[0]), q[4:1]}; // XOR tap positions 5 and 3 with q[0] to generate next state
  end
end

endmodule