module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    // Feedback XOR logic with taps at bit positions 5 and 3
    q <= {q[4] ^ (q[3] ^ q[0]), q[4], q[3], q[2], q[1]}; // Implementing the correct XOR operations for taps
  end
end

endmodule