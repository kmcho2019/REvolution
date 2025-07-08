module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk) begin
  if (reset) begin
    q <= 5'b00001;  // Active-high reset to 1
  end else begin
    // Galois LFSR with taps at positions 5 (feedback) and 3 (q[2] in 0-based)
    q <= {q[0] ^ q[2], q[4:1]};
  end
end

endmodule