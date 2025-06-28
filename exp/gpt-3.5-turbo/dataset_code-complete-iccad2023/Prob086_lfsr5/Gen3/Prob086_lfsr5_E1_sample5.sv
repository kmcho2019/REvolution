module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg feedback; // Feedback bit calculated using XOR gate

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    feedback = q[4] ^ q[2] ^ q[0]; // Calculate feedback using XOR gate at taps 5 and 3
    if ((q[4] ^ q[0]) == 1'b1) begin
      q <= {feedback, q[4:1]}; // Update LFSR state with feedback bit
    end else begin
      q <= {q[4], q[4:1]}; // No update on LFSR state
    end
  end
end

endmodule