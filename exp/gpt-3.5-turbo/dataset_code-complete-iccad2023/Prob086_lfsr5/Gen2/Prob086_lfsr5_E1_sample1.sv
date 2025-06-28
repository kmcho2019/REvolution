module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg [4:0] current_state; // Register to hold the current state of the LFSR
reg [4:0] next_state;    // Register to hold the next state of the LFSR

always @(posedge clk or posedge reset) begin
  if (reset) begin
    current_state <= 5'b1; // Reset LFSR output to 1
  end else begin
    // Calculate next_state based on the taps and shifting
    next_state[4] <= current_state[3] ^ current_state[0]; // XOR operation for tap at position 3
    next_state[3] <= current_state[1]; // Shift right for bit position 3
    next_state[2] <= current_state[2]; // Shift right for bit position 2
    next_state[1] <= current_state[3]; // Shift right for bit position 1
    next_state[0] <= current_state[4] ^ current_state[0]; // XOR operation for tap at position 5

    // Update current_state with next_state for the next cycle
    current_state <= next_state;
  end
end

assign q = current_state;

endmodule