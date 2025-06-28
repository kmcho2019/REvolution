module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg feedback_5, feedback_3;

// Generate feedback values based on tap positions 5 and 3
always @(posedge clk or posedge reset) begin
  if (reset) begin
    feedback_5 <= 1'b0; // Feedback from tap position 5
    feedback_3 <= 1'b0; // Feedback from tap position 3
  end else begin
    feedback_5 <= q[4] ^ q[3]; // XOR tap position 5 with q[4]
    feedback_3 <= q[4] ^ q[2]; // XOR tap position 3 with q[4]
  end
end

// State update based on the feedback values
always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    q <= {q[3] ^ feedback_5, q[4:1]} ^ feedback_3; // XOR feedback values with current state to generate next state
  end
end

endmodule