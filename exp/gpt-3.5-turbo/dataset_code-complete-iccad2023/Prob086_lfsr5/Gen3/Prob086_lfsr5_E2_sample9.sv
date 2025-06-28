module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg [4:0] next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    // Generate next state based on taps at positions 5 and 3
    next_state[0] <= q[4] ^ q[0] ^ q[2]; // Feedback logic
    next_state[1] <= q[0];
    next_state[2] <= q[1];
    next_state[3] <= q[2];
    next_state[4] <= q[3];

    // Shift the LFSR to the right
    q <= next_state;
  end
end

endmodule