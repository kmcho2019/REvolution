module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

// Define states for the state machine
typedef enum logic [4:0] {
  IDLE,
  DETECT_START_PATTERN,
  SHIFT_IN_BITS_1,
  SHIFT_IN_BITS_2,
  SHIFT_IN_BITS_3,
  SHIFT_IN_BITS_4,
  WAIT_FOR_COUNTERS,
  TIMER_COMPLETE,
  WAIT_FOR_ACK
} state_t;

// State and next state registers
reg [4:0] state, next_state;

// State machine logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// Default next state and outputs
always @* begin
  shift_ena = 0;
  counting = 0;
  done = 0;
  
  // State transitions and outputs
  case (state)
    IDLE: begin
      if (data == 4'b1101) begin
        next_state = DETECT_START_PATTERN;
      end
    end
    
    DETECT_START_PATTERN: begin
      shift_ena = 1;
      next_state = SHIFT_IN_BITS_1;
    end
    
    SHIFT_IN_BITS_1: begin
      next_state = SHIFT_IN_BITS_2;
    end
    
    SHIFT_IN_BITS_2: begin
      next_state = SHIFT_IN_BITS_3;
    end
    
    SHIFT_IN_BITS_3: begin
      next_state = SHIFT_IN_BITS_4;
    end
    
    SHIFT_IN_BITS_4: begin
      shift_ena = 1;
      counting = 1;
      next_state = WAIT_FOR_COUNTERS;
    end
    
    WAIT_FOR_COUNTERS: begin
      if (done_counting) begin
        next_state = TIMER_COMPLETE;
      end
    end
    
    TIMER_COMPLETE: begin
      done = 1;
      next_state = WAIT_FOR_ACK;
    end
    
    WAIT_FOR_ACK: begin
      if (ack) begin
        next_state = IDLE;
      end
    end
    
    default: next_state = IDLE;
  endcase
end

endmodule