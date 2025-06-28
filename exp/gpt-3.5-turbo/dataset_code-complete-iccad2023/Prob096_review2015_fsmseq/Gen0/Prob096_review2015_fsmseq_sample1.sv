module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states for the finite-state machine
parameter [1:0] IDLE = 2'b00;
parameter [1:0] STATE_1 = 2'b01;
parameter [1:0] STATE_2 = 2'b10;
parameter [1:0] DETECTED = 2'b11;

// Declare state register and next state variable
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset)
begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

always @ *
begin
  // Default next state values
  next_state = state;
  start_shifting = 0;

  // State transitions and output logic
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
        next_state = DETECTED;
        start_shifting = 1;
    end
  endcase
end

endmodule