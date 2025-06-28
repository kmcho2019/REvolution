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

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    start_shifting <= 0;
  end
  else begin
    state <= next_state;
    // Initialize to 0 to avoid latches
    start_shifting <= 0;
  end
end

always @* begin
  // Default next state value
  next_state = state;

  // State transitions and output logic
  case(state)
    IDLE: begin
      if (data == 1)
        next_state = STATE_1;
    end

    STATE_1: begin
      if (data == 1)
        next_state = STATE_2;
      else
        next_state = IDLE;
    end

    STATE_2: begin
      if (data == 1)
        next_state = DETECTED;
      else
        next_state = IDLE;
    end

    DETECTED: begin
      if (reset)
        next_state = IDLE;
      start_shifting = 1; // Set start_shifting to 1 in the DETECTED state
    end
  endcase
end

endmodule