module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    // Determine next state using combinatorial logic for taps at positions 5 and 3
    reg feedback;
    feedback = q[4] ^ q[2] ^ q[0]; // XOR tap positions 5 and 3 with LSB output bit
    q <= {feedback, q[4:1]}; // Shift the LFSR with the feedback for the next state
  end
end

endmodule