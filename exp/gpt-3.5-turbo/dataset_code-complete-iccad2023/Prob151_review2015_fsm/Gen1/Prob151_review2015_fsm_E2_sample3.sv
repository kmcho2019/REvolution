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
    DETECTED,
    SHIFT_IN_BITS,
    WAIT_FOR_COUNTERS,
    TIMED_OUT,
    WAIT_FOR_ACK
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
      IDLE: begin
        shift_ena = 0;
        counting = 0;
        if (data == 4'b1101) begin
          next_state = DETECTED;
        end
      end
      
      DETECTED: begin
        shift_ena = 1;
        if (counting == 4) begin
          next_state = WAIT_FOR_COUNTERS;
        end
      end
      
      SHIFT_IN_BITS: begin
        // Implement the logic to shift in 4 bits
        counting = 1;
        if (counting == 4) begin
          next_state = WAIT_FOR_COUNTERS;
        end
      end
      
      WAIT_FOR_COUNTERS: begin
        shift_ena = 0;
        if (done_counting) begin
          next_state = TIMED_OUT;
        end
      end
      
      TIMED_OUT: begin
        done = 1;
        next_state = WAIT_FOR_ACK;
      end
      
      WAIT_FOR_ACK: begin
        if (ack) begin
          next_state = IDLE;
        end
      end
    endcase
  end  
endmodule