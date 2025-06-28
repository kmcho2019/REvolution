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
  typedef enum logic [2:0] {
    IDLE,
    DETECT_PATTERN,
    SHIFT_IN_BITS,
    WAITING_FOR_COUNTERS,
    NOTIFY_USER
  } state_type;
  
  // Define registers for state machine
  reg [2:0] state, next_state;
  
  // State machine logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Default next state (no state change)
  always @* begin
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;
    
    // State transitions and outputs
    case (state)
      IDLE:
        if (data == 4'b1101) begin
          next_state = DETECT_PATTERN;
        end
      DETECT_PATTERN:
        begin
          shift_ena = 1;
          next_state = SHIFT_IN_BITS;
        end
      SHIFT_IN_BITS:
        begin
          if (shift_ena < 4) begin
            shift_ena = shift_ena + 1;
          end else begin
            counting = 1;
            next_state = WAITING_FOR_COUNTERS;
          end
        end
      WAITING_FOR_COUNTERS:
        if (done_counting) begin
          next_state = NOTIFY_USER;
        end
      NOTIFY_USER:
        begin
          done = 1;
          if (ack) begin
            next_state = IDLE;
          end
        end
    endcase
  end
endmodule