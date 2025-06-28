module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Initialize LFSR output to 1 on reset
  end
  else begin
    // Galois LFSR feedback logic with taps at bit positions 5 and 3
    q <= {q[4] ^ (q[4] ^ q[2] ^ q[0]), q[4:1]}; // XOR tapped bits with q[0] and shift right
  end
end

endmodule