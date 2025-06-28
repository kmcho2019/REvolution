module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states for the finite-state machine
parameter IDLE = 2'b00;
parameter STATE_1 = 2'b01;
parameter STATE_2 = 2'b10;
parameter DETECTED = 2'b11;

// Declare state register and next state variable
reg [1:0] state, next_state;
// Register to store the last four bits
reg [3:0] last_four_bits;

always @ (posedge clk or posedge reset)
begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

always @ (state, data)
begin
  // Default next state values
  next_state = state;
  start_shifting = (state == DETECTED) ? 1'b1 : 1'b0;

  // State transitions and logic to detect sequence '1101'
  case(state)
    IDLE: begin
      if (data)
        next_state = STATE_1;
    end

    STATE_1: begin
      if (data)
        next_state = STATE_2;
      else
        next_state = IDLE;
    end

    STATE_2: begin
      if (data)
        next_state = DETECTED;
      else
        next_state = IDLE;
    end

    DETECTED: begin
      next_state = reset ? IDLE : DETECTED;
    end
  endcase

  // Update last_four_bits with the latest data
  last_four_bits <= {last_four_bits[2:0], data};

  // Check for sequence '1101'
  if (last_four_bits == 4'b1101)
    next_state = DETECTED;

end

endmodule