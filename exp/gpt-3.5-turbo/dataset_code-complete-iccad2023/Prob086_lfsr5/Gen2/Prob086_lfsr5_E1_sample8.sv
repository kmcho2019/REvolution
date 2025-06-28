module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Set initial state to 1 on reset
  end else begin
    // Calculating the next state based on taps at positions 5 and 3
    q <= {q[4] ^ q[0] ^ q[2], q[4:1]}; // XOR tapped bits with output LSB bit for Galois LFSR
  end
end

endmodule